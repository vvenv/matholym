import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Borderless hit target: hover tint, keyboard focus, button semantics.
/// Ink paints under [child], so keep opaque backgrounds outside of it.
class QuietTap extends StatelessWidget {
  const QuietTap({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.tooltip,
    this.onHighlight,
  });

  final VoidCallback? onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? tooltip;

  /// Pointer hover or keyboard focus entered (true) or left (false).
  final ValueChanged<bool>? onHighlight;

  @override
  Widget build(BuildContext context) {
    Widget tap = Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onHover: onHighlight,
          onFocusChange: onHighlight,
          splashFactory: NoSplash.splashFactory,
          hoverColor: AppColors.surface,
          highlightColor: AppColors.surface2,
          focusColor: AppColors.surface2,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    if (tooltip != null) tap = Tooltip(message: tooltip!, child: tap);
    return tap;
  }
}
