import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/quiet_tap.dart';
import '../../core/widgets/study_bar.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';
import '../tree/tree_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(graphViewProvider).valueOrNull;
    final wrongCount = ref.watch(wrongOpenCountProvider).valueOrNull ?? 0;
    final mode = ref.watch(treeLayoutModeProvider);
    final areaTitle =
        view?.graph.area.title ?? KnowledgeArea.numberTheory.title;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: TreePage()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StudyBar(
              padding: const EdgeInsets.only(
                left: AppSpace.page,
                right: AppSpace.page - 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _AreaSwitch(title: areaTitle),
                  if (view != null) ...[
                    const SizedBox(width: 10),
                    Text(
                      '掌握 ${view.mastered.length}/${view.graph.nodes.length}',
                      style: AppType.tabular.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                  const Spacer(),
                  _ModeSwitch(
                    mode: mode,
                    onChanged: (m) =>
                        ref.read(treeLayoutModeProvider.notifier).state = m,
                  ),
                  const SizedBox(width: 8),
                  _BarText(
                    label: wrongCount > 0 ? '错题 $wrongCount' : '错题',
                    onTap: () => context.push('/wrongbook'),
                  ),
                  PopupMenuButton<_ShellAction>(
                    tooltip: '更多',
                    position: PopupMenuPosition.under,
                    padding: const EdgeInsets.all(8),
                    style: IconButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      hoverColor: AppColors.surface,
                      highlightColor: AppColors.surface2,
                    ),
                    constraints: const BoxConstraints(minWidth: 120),
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: AppColors.muted,
                    ),
                    onSelected: (action) => switch (action) {
                      _ShellAction.reset => _confirmReset(context, ref),
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _ShellAction.reset,
                        height: 40,
                        child: Text(
                          '清空进度',
                          style: AppType.meta.copyWith(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空进度', style: AppType.title),
        content: const Text('掌握记录和错题都会删掉，无法恢复。', style: AppType.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.text,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final repo = await ref.read(repositoryProvider.future);
    final profile = await ref.read(profileProvider.future);
    if (profile == null) return;
    await repo.resetProgress(profile.id);
    ref.invalidate(areaViewProvider);
    ref.invalidate(wrongOpenCountProvider);
  }
}

enum _ShellAction { reset }

class _AreaSwitch extends ConsumerWidget {
  const _AreaSwitch({required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areas = KnowledgeArea.planned
        .where((area) => area.available)
        .toList();
    final current = ref.watch(selectedAreaIdProvider);
    if (areas.length <= 1) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          height: 1.2,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
        ),
      );
    }
    return PopupMenuButton<String>(
      tooltip: '知识面',
      position: PopupMenuPosition.under,
      initialValue: current,
      padding: const EdgeInsets.all(4),
      style: IconButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        hoverColor: AppColors.surface,
        highlightColor: AppColors.surface2,
      ),
      onSelected: (id) {
        ref.read(selectedAreaIdProvider.notifier).state = id;
      },
      itemBuilder: (_) => [
        for (final area in areas)
          PopupMenuItem(
            value: area.id,
            height: 40,
            child: Text(
              area.title,
              style: AppType.body.copyWith(
                fontSize: 15,
                color: area.id == current ? AppColors.text : AppColors.muted,
              ),
            ),
          ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              height: 1.2,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.expand_more, size: 16, color: AppColors.muted),
        ],
      ),
    );
  }
}

/// Two hairline cells; the chosen one is filled a shade lighter.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.mode, required this.onChanged});

  final TreeLayoutMode mode;
  final ValueChanged<TreeLayoutMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: AppColors.line)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in TreeLayoutMode.values)
            Semantics(
              selected: m == mode,
              child: ColoredBox(
                color: m == mode ? AppColors.surface2 : Colors.transparent,
                child: QuietTap(
                  onTap: () => onChanged(m),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    m == TreeLayoutMode.list ? '列表' : '树',
                    style: AppType.meta.copyWith(
                      fontSize: 12,
                      letterSpacing: 0.4,
                      color: m == mode ? AppColors.text : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarText extends StatelessWidget {
  const _BarText({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QuietTap(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(label, style: AppType.meta),
    );
  }
}
