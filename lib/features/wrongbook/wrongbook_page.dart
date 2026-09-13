import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_figure.dart';
import '../../core/widgets/math_text.dart';
import '../../core/widgets/quiet_tap.dart';
import '../../core/widgets/study_bar.dart';
import '../../data/repositories/app_repository.dart';
import '../../domain/figure.dart';
import '../../domain/generators/catalog.dart';
import '../../providers.dart';
import '../practice/practice_controller.dart';

final _wrongListProvider = FutureProvider<List<WrongItemView>>((ref) async {
  // Any recount (redo, cause change, reset) means the list moved too.
  await ref.watch(wrongOpenCountProvider.future);
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return const [];
  return repo.listWrongItems(profileId: profile.id);
});

const _rowInset = 12.0;

class WrongBookPage extends ConsumerStatefulWidget {
  const WrongBookPage({super.key});

  @override
  ConsumerState<WrongBookPage> createState() => _WrongBookPageState();
}

class _WrongBookPageState extends ConsumerState<WrongBookPage> {
  /// Rows showing their answer. Closed by default so the list stays a quiz.
  final _open = <int>{};

  /// Open the card and move the tree to the subject it belongs to, so going
  /// back from a wrong answer in algebra lands in the algebra tree.
  void _review(String nodeId) {
    final areaId = ref.read(seedStoreProvider).valueOrNull?.areaIdOf(nodeId);
    if (areaId != null) {
      ref.read(selectedAreaIdProvider.notifier).state = areaId;
    }
    context.push('/card/$nodeId');
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(_wrongListProvider);
    final seeds = ref.watch(seedStoreProvider).valueOrNull;
    final count = items.valueOrNull?.length ?? 0;

    String? titleOf(String nodeId) => seeds?.nodeOrNull(nodeId)?.title;

    return Scaffold(
      body: Column(
        children: [
          StudyBar.page(title: '错题'),
          Expanded(
            child: items.when(
              loading: () => const QuietProgress(),
              error: (e, _) => Center(child: Text('$e', style: AppType.body)),
              data: (list) {
                if (list.isEmpty) return const _Empty();
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpace.column,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.page - _rowInset,
                        AppSpace.sm,
                        AppSpace.page - _rowInset,
                        24,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final reviewId = item.attributedNodeId.isEmpty
                            ? item.nodeId
                            : item.attributedNodeId;
                        return _WrongRow(
                          number: index + 1,
                          item: item,
                          nodeTitle: titleOf(item.nodeId),
                          reviewTitle: titleOf(reviewId),
                          open: _open.contains(item.id),
                          onToggle: () => setState(() {
                            if (!_open.remove(item.id)) _open.add(item.id);
                          }),
                          onReview: () => _review(reviewId),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (count > 0)
            StudyDock(
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () => context.push('/practice?mode=redo'),
                    child: Text('重练 ${min(kRedoBatch, count)} 题'),
                  ),
                  const SizedBox(width: AppSpace.md),
                  const Expanded(
                    child: Text(
                      '重练做对，就从这里移出',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.meta,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _WrongRow extends StatelessWidget {
  const _WrongRow({
    required this.number,
    required this.item,
    required this.nodeTitle,
    required this.reviewTitle,
    required this.open,
    required this.onToggle,
    required this.onReview,
  });

  final int number;
  final WrongItemView item;
  final String? nodeTitle;
  final String? reviewTitle;
  final bool open;
  final VoidCallback onToggle;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      expanded: open,
      child: QuietTap(
        onTap: onToggle,
        padding: const EdgeInsets.symmetric(
          horizontal: _rowInset,
          vertical: AppSpace.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Text(
                number.toString().padLeft(2, '0'),
                style: AppType.tabular.copyWith(color: AppColors.faint),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MathText(item.stem),
                  if (_figureOf(item) case final fig?) ...[
                    const SizedBox(height: AppSpace.sm),
                    MathFigureView(figure: fig, height: 132),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (nodeTitle != null)
                        Expanded(child: Text(nodeTitle!, style: AppType.meta))
                      else
                        const Spacer(),
                      Text(
                        open ? '收起' : '看答案',
                        // The whole row is the target; the label only names it.
                        style: AppType.meta.copyWith(
                          color: open ? AppColors.faint : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: reduce
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topLeft,
                    child: open
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSpace.sm),
                            child: _Answer(
                              answer: item.answer,
                              reviewTitle: reviewTitle,
                              onReview: onReview,
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MathFigure? _figureOf(WrongItemView item) {
  try {
    return questionEngine
        .generate(templateId: item.templateId, seed: item.seed)
        .figure;
  } catch (_) {
    return null;
  }
}

class _Answer extends StatelessWidget {
  const _Answer({
    required this.answer,
    required this.reviewTitle,
    required this.onReview,
  });

  final String answer;
  final String? reviewTitle;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text('答案', style: AppType.meta),
            const SizedBox(width: 12),
            Flexible(child: AnswerText(answer, color: AppColors.mastered)),
          ],
        ),
        if (reviewTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: QuietTap(
              onTap: onReview,
              padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
              child: Text(
                '复习「$reviewTitle」',
                style: AppType.meta.copyWith(color: AppColors.text),
              ),
            ),
          ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpace.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('没有待消化的错题', style: AppType.body),
            SizedBox(height: AppSpace.xs),
            Text(
              '做错的题会收在这里，重练做对后自动移出。',
              textAlign: TextAlign.center,
              style: AppType.meta,
            ),
          ],
        ),
      ),
    );
  }
}
