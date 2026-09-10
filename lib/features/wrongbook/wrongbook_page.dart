import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../core/widgets/math_text.dart';
import '../../data/repositories/app_repository.dart';
import '../../domain/mastery.dart';
import '../../domain/wrong_book.dart';
import '../../providers.dart';

String _filterTitle(({String? nodeId, ErrorCause? cause}) filter, GraphView? graph) {
  final parts = <String>[];
  if (filter.nodeId != null) {
    try {
      parts.add(graph?.graph.nodeById(filter.nodeId!).title ?? filter.nodeId!);
    } catch (_) {
      parts.add(filter.nodeId!);
    }
  }
  if (filter.cause != null) {
    parts.add(filter.cause!.label);
  }
  return parts.isEmpty ? '筛选' : '筛选 · ${parts.join(' · ')}';
}

final _wrongFilterProvider = StateProvider<({String? nodeId, ErrorCause? cause})>(
  (ref) => (nodeId: null, cause: null),
);

final _wrongListProvider = FutureProvider<List<WrongItemView>>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return const [];
  final filter = ref.watch(_wrongFilterProvider);
  return repo.listWrongItems(
    profileId: profile.id,
    nodeId: filter.nodeId,
    cause: filter.cause,
  );
});

class WrongBookPage extends ConsumerWidget {
  const WrongBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_wrongListProvider);
    final graph = ref.watch(graphViewProvider).valueOrNull;
    final filter = ref.watch(_wrongFilterProvider);
    final nodes = graph?.graph.nodes.where((n) => n.practiceReady).toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('错题本'),
        actions: [
          TextButton(
            onPressed: items.valueOrNull?.isEmpty ?? true
                ? null
                : () => context.push('/practice?mode=redo'),
            child: const Text('重练 5 题'),
          ),
        ],
      ),
      body: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(_filterTitle(filter, graph)),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('全部节点'),
                        selected: filter.nodeId == null,
                        onSelected: (_) =>
                            ref.read(_wrongFilterProvider.notifier).state =
                                (nodeId: null, cause: filter.cause),
                      ),
                      const SizedBox(width: 8),
                      for (final node in nodes) ...[
                        FilterChip(
                          label: Text(node.title),
                          selected: filter.nodeId == node.id,
                          onSelected: (_) =>
                              ref.read(_wrongFilterProvider.notifier).state =
                                  (nodeId: node.id, cause: filter.cause),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('全部错因'),
                        selected: filter.cause == null,
                        onSelected: (_) =>
                            ref.read(_wrongFilterProvider.notifier).state =
                                (nodeId: filter.nodeId, cause: null),
                      ),
                      const SizedBox(width: 8),
                      for (final cause in ErrorCause.values) ...[
                        FilterChip(
                          label: Text(cause.label),
                          selected: filter.cause == cause,
                          onSelected: (_) =>
                              ref.read(_wrongFilterProvider.notifier).state =
                                  (nodeId: filter.nodeId, cause: cause),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text('暂无未消化错题', style: TextStyle(color: AppColors.muted)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final nodeTitle = graph?.graph.nodeById(item.nodeId).title ?? item.nodeId;
                    String attrTitle = item.attributedNodeId;
                    try {
                      attrTitle = graph?.graph.nodeById(item.attributedNodeId).title ?? attrTitle;
                    } catch (_) {}
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(nodeTitle, style: const TextStyle(color: AppColors.info)),
                                const SizedBox(width: 4),
                                InfoTip('归因到：$attrTitle'),
                                const Spacer(),
                                Text(item.cause.label, style: const TextStyle(color: AppColors.warn, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            MathText(item.stem),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.push('/card/${item.nodeId}'),
                                child: const Text('查看节点'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
