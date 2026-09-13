import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const bg = Color(0xFF0C0C0B);
  static const surface = Color(0xFF161614);
  static const line = Color(0xFF302F2A);

  /// Hover and focus edge for framed controls.
  static const lineStrong = Color(0xFF4C4A43);
  static const text = Color(0xFFE8E6DE);

  /// Secondary copy. Kept above 6:1 on [bg] so small labels stay legible.
  static const muted = Color(0xFF99958B);

  /// Numbering and ticks: present, but a step behind [muted].
  static const faint = Color(0xFF625F57);

  /// Reserved for the one thing to do next on a screen.
  static const accent = Color(0xFFC9A46C);
  static const ink = Color(0xFF14140F);
  static const locked = Color(0xFF4A4943);
  static const mastered = Color(0xFF6E8B74);
  static const danger = Color(0xFFC46B5A);

  static const info = accent;
  static const warn = accent;
  static const border = line;
  static const surface2 = Color(0xFF1C1C18);
}

class AppSpace {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 20.0;
  static const lg = 32.0;
  static const xl = 48.0;
  static const page = 20.0;

  /// Reading column, page padding included. Bar, body, and dock share it.
  static const column = 520.0;
}

class AppType {
  static const mark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
    height: 1.2,
    color: AppColors.muted,
  );

  static const display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.5,
    height: 1.25,
    color: AppColors.text,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.35,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.75,
    color: AppColors.text,
  );

  static const meta = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.6,
    height: 1.3,
    color: AppColors.muted,
  );

  static const tabular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.muted,
  );
}

class QuietProgress extends StatelessWidget {
  const QuietProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 96,
        child: LinearProgressIndicator(minHeight: 1),
      ),
    );
  }
}

class PageColumn extends StatelessWidget {
  const PageColumn({
    super.key,
    required this.children,
    this.maxWidth = AppSpace.column,
    this.padding = const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.md, AppSpace.page, 40),
  });

  final List<Widget> children;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          padding: padding,
          children: children,
        ),
      ),
    );
  }
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    surface: AppColors.surface,
    primary: AppColors.accent,
    secondary: AppColors.accent,
    error: AppColors.danger,
    onSurface: AppColors.text,
    onPrimary: AppColors.ink,
    outline: AppColors.line,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    splashFactory: InkRipple.splashFactory,
    dividerColor: AppColors.line,
    textTheme: const TextTheme(
      displayLarge: AppType.display,
      titleMedium: AppType.title,
      bodyLarge: AppType.body,
      bodyMedium: AppType.body,
      labelLarge: AppType.meta,
      labelSmall: AppType.mark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpace.page,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: AppColors.text,
      ),
      iconTheme: IconThemeData(color: AppColors.muted, size: 20),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      isDense: true,
      labelStyle: AppType.meta,
      hintStyle: AppType.meta,
      border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.line)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.line)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.ink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.line),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: const RoundedRectangleBorder(),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    ),
    tooltipTheme: const TooltipThemeData(
      waitDuration: Duration(milliseconds: 400),
      textStyle: TextStyle(fontSize: 12, color: AppColors.text, height: 1.35),
      decoration: BoxDecoration(color: AppColors.surface2),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bg,
      elevation: 0,
      height: 64,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          letterSpacing: 0.8,
          fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          color: selected ? AppColors.text : AppColors.muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 20,
          color: selected ? AppColors.accent : AppColors.muted,
        );
      }),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppColors.line),
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: AppColors.muted,
      collapsedIconColor: AppColors.muted,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(bottom: AppSpace.md),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.surface2,
      elevation: 0,
      menuPadding: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppColors.line),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
      linearTrackColor: AppColors.line,
    ),
  );
}
