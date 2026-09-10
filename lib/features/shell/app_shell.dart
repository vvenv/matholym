import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _Dock(navigationShell: navigationShell),
    );
  }
}

class _Dock extends StatelessWidget {
  const _Dock({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final shell = navigationShell;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              _DockItem(
                label: '知识树',
                selected: shell.currentIndex == 0,
                onTap: () => shell.goBranch(0),
              ),
              _DockItem(
                label: '错题本',
                selected: shell.currentIndex == 1,
                onTap: () => shell.goBranch(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppType.mark.copyWith(
                color: selected ? AppColors.text : AppColors.muted,
              ),
            ),
            const SizedBox(height: 6),
            ColoredBox(
              color: selected ? AppColors.accent : Colors.transparent,
              child: const SizedBox(width: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
