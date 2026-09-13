import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'quiet_tap.dart';

class StudyBar extends StatelessWidget {
  const StudyBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpace.page),
  });

  final Widget child;
  final EdgeInsets padding;

  static const height = 52.0;

  factory StudyBar.page({
    Key? key,
    String title = '',
    bool close = false,
    VoidCallback? onPop,
    List<Widget> actions = const [],
  }) {
    return StudyBar(
      key: key,
      // The icon carries its own hit padding; keep the glyph on the column edge.
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.page - 8),
      child: Row(
        children: [
          _IconHit(
            icon: close ? Icons.close : Icons.arrow_back,
            tooltip: close ? '关闭' : '返回',
            onPressed: onPop,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.meta.copyWith(fontSize: 14, color: AppColors.text),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.column),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconHit extends StatelessWidget {
  const _IconHit({required this.icon, required this.tooltip, this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return QuietTap(
      tooltip: tooltip,
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, size: 20, color: AppColors.muted),
    );
  }
}

class StudyDock extends StatelessWidget {
  const StudyDock({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpace.page),
  });

  final Widget child;

  /// Horizontal inset; vertical rhythm is fixed.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpace.column),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: padding.copyWith(top: 10, bottom: 10),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
