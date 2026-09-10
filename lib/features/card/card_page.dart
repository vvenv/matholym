import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_text.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';

class CardPage extends ConsumerWidget {
  const CardPage({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphViewProvider);
    final seeds = ref.watch(seedStoreProvider);

    return graph.when(
      loading: () => const Scaffold(body: QuietProgress()),
      error: (e, _) => Scaffold(body: Center(child: Text('$e', style: AppType.body))),
      data: (view) {
        final node = view.graph.nodeById(nodeId);
        final status = view.statusOf(node.id);
        final card = seeds.valueOrNull?.cardFor(node.id);
        final extras = [
          ...?card?.theorems,
          ...?card?.examples,
          ...?card?.commonMistakes,
        ];
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 18),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(node.title, style: AppType.mark.copyWith(fontSize: 14)),
          ),
          body: PageColumn(
            children: [
              MathText(card?.definition ?? '加载中…'),
              if (extras.isNotEmpty) ...[
                const SizedBox(height: AppSpace.lg),
                const Divider(),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('更多', style: AppType.mark),
                    children: [
                      for (final item in extras)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpace.md),
                          child: MathText(item, style: AppType.body.copyWith(color: AppColors.muted)),
                        ),
                    ],
                  ),
                ),
              ],
              if (node.practiceReady && status != NodeStatus.locked) ...[
                const SizedBox(height: AppSpace.xl),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () => context.push(
                      '/practice?mode=challenge&nodeId=${node.id}',
                    ),
                    child: const Text('闯关'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
