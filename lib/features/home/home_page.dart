import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../core/widgets/status_badge.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final graph = ref.watch(graphViewProvider);
    final wrongs = ref.watch(wrongOpenCountProvider);
    final attempts = ref.watch(totalAttemptsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Brand.appName),
        actions: [
          IconButton(
            tooltip: '重置进度',
            onPressed: () => _confirmReset(context, ref),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (p) {
          if (p == null) return const SizedBox.shrink();
          final view = graph.valueOrNull;
          final rec = view?.recommended();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                '你好，${p.nickname}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    StudentStage.parse(p.stage).label,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(width: 4),
                  const InfoTip('进度保存在本机，无需登录。第一期只开放数论，其他知识面会陆续种上。'),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final area in KnowledgeArea.planned)
                    FilterChip(
                      label: Text(area.title),
                      selected: area.available &&
                          (view?.graph.area.id ?? KnowledgeArea.numberTheoryId) ==
                              area.id,
                      onSelected: area.available ? (_) {} : null,
                      tooltip: area.available ? area.blurb : '即将开放',
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: '练习量',
                      value: '${attempts.valueOrNull ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: '未消化错题',
                      value: '${wrongs.valueOrNull ?? 0}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (rec != null && view != null)
                _ContinueCard(
                  title: rec.title,
                  subtitle: rec.subtitle,
                  status: view.statusOf(rec.id),
                  ready: rec.practiceReady,
                  onChallenge: rec.practiceReady
                      ? () => context.push(
                          '/practice?mode=challenge&nodeId=${rec.id}',
                        )
                      : null,
                  onOpen: () => context.push('/card/${rec.id}'),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: (wrongs.valueOrNull ?? 0) == 0
                    ? null
                    : () => context.push('/practice?mode=redo'),
                icon: const Icon(Icons.replay),
                label: const Text('重练 5 道错题'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置进度？'),
        content: const Text('练习记录、掌握状态和错题本都会清空，知识树回到起点。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('重置')),
        ],
      ),
    );
    if (ok != true) return;
    final repo = await ref.read(repositoryProvider.future);
    final profile = await ref.read(profileProvider.future);
    if (profile == null) return;
    await repo.resetProgress(profile.id);
    ref.invalidate(graphViewProvider);
    ref.invalidate(wrongOpenCountProvider);
    ref.invalidate(totalAttemptsProvider);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.ready,
    required this.onOpen,
    this.onChallenge,
  });

  final String title;
  final String subtitle;
  final NodeStatus status;
  final bool ready;
  final VoidCallback onOpen;
  final VoidCallback? onChallenge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('继续练习', style: TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                if (subtitle.isNotEmpty) InfoTip(subtitle),
                const SizedBox(width: 6),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(onPressed: onOpen, child: const Text('知识卡片')),
                const SizedBox(width: 8),
                if (ready)
                  OutlinedButton(onPressed: onChallenge, child: const Text('闯关')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
