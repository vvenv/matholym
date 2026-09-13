import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'math_text.dart';

/// A labelled block of study copy: a small tick and label, content below.
/// Card sections and practice feedback share it so they read as one voice.
class StudySection extends StatelessWidget {
  const StudySection({
    super.key,
    required this.label,
    required this.child,
    this.tick = AppColors.faint,
  });

  /// Plain TeX lines, one block each.
  factory StudySection.lines({
    Key? key,
    required String label,
    required List<String> lines,
    Color tick = AppColors.faint,
    Color? color,
  }) {
    return StudySection(
      key: key,
      label: label,
      tick: tick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpace.sm),
              child: MathText(lines[i], color: color),
            ),
        ],
      ),
    );
  }

  final String label;
  final Widget child;
  final Color tick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Row(
            children: [
              ColoredBox(color: tick, child: const SizedBox(width: 5, height: 5)),
              const SizedBox(width: 10),
              Text(label, style: AppType.meta.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
