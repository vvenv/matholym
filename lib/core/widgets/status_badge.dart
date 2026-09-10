import 'package:flutter/material.dart';

import '../../domain/knowledge/models.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final NodeStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      NodeStatus.locked => ('未解锁', AppColors.locked),
      NodeStatus.learning => ('学习中', AppColors.info),
      NodeStatus.mastered => ('已掌握', AppColors.accent),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
