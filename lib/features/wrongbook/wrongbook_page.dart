import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_text.dart';
import '../../data/repositories/app_repository.dart';
import '../../providers.dart';

final _wrongListProvider = FutureProvider<List<WrongItemView>>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return const [];
  return repo.listWrongItems(profileId: profile.id);
});

class WrongBookPage extends ConsumerWidget {
  const WrongBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_wrongListProvider);
    final hasItems = items.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('错题'),
        actions: [
          if (hasItems)
            TextButton(
              onPressed: () => context.push('/practice?mode=redo'),
              child: const Text('重练'),
            ),
        ],
      ),
      body: items.when(
        loading: () => const QuietProgress(),
        error: (e, _) => Center(child: Text('$e', style: AppType.body)),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('没有错题', style: AppType.meta));
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.sm, AppSpace.page, 40),
                itemCount: list.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return InkWell(
                    onTap: () => context.push('/card/${item.nodeId}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 36,
                            child: Text(
                              (index + 1).toString().padLeft(2, '0'),
                              style: AppType.tabular,
                            ),
                          ),
                          Expanded(child: MathText(item.stem)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
