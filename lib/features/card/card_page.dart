import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../core/widgets/math_text.dart';
import '../../core/widgets/status_badge.dart';
import '../../domain/generators/question.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';

class CardPage extends ConsumerStatefulWidget {
  const CardPage({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<CardPage> createState() => _CardPageState();
}

class _CardPageState extends ConsumerState<CardPage> {
  Difficulty _difficulty = Difficulty.basic;

  @override
  Widget build(BuildContext context) {
    final graph = ref.watch(graphViewProvider);
    final seeds = ref.watch(seedStoreProvider);

    return graph.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (view) {
        final node = view.graph.nodeById(widget.nodeId);
        final status = view.statusOf(node.id);
        final card = seeds.valueOrNull?.cardFor(node.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(node.title),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(child: StatusBadge(status: status)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Row(
                children: [
                  Text(node.level.label, style: const TextStyle(color: AppColors.info)),
                  if (node.subtitle.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    InfoTip(node.subtitle),
                  ],
                  if (node.prerequisites.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    InfoTip(
                      '前置：${node.prerequisites.map((id) => view.graph.nodeById(id).title).join('、')}',
                    ),
                  ],
                  if (!node.practiceReady) ...[
                    const SizedBox(width: 4),
                    const InfoTip(
                      '该节点本期仅开放知识卡片，练习将在后续版本加入。',
                      icon: Icons.lock_outline,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _Section(title: '定义', child: MathText(card?.definition ?? '加载中…')),
              _Fold(
                title: '关键定理',
                child: _Bullets(card?.theorems ?? const []),
              ),
              _Fold(
                title: '典型例题',
                child: _Bullets(card?.examples ?? const []),
              ),
              _Fold(
                title: '常见错误',
                child: _Bullets(card?.commonMistakes ?? const []),
              ),
              const SizedBox(height: 12),
              if (status == NodeStatus.locked)
                const Text('节点尚未解锁。', style: TextStyle(color: AppColors.muted))
              else if (node.practiceReady) ...[
                const Text('专项难度', style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 8),
                SegmentedButton<Difficulty>(
                  segments: [
                    for (final d in Difficulty.values)
                      ButtonSegment(value: d, label: Text(d.label)),
                  ],
                  selected: {_difficulty},
                  onSelectionChanged: (s) => setState(() => _difficulty = s.first),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push(
                    '/practice?mode=challenge&nodeId=${node.id}',
                  ),
                  child: const Text('闯关练习 · 5 题'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.push(
                    '/practice?mode=special&nodeId=${node.id}&difficulty=${_difficulty.name}',
                  ),
                  child: const Text('专项练习 · 10 题'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _Fold extends StatelessWidget {
  const _Fold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        children: [
          Align(alignment: Alignment.centerLeft, child: child),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('—', style: TextStyle(color: AppColors.muted));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('·  ', style: TextStyle(color: AppColors.info)),
                Expanded(child: MathText(item)),
              ],
            ),
          ),
      ],
    );
  }
}
