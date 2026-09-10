import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'providers.dart';

class MatholymApp extends ConsumerWidget {
  const MatholymApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final seeds = ref.watch(seedStoreProvider);
    if (profile.hasError || seeds.hasError) {
      return MaterialApp(
        title: '数论之树',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '启动失败：${profile.error ?? seeds.error}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    if (profile.isLoading || seeds.isLoading) {
      return MaterialApp(
        title: '数论之树',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: '数论之树',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
