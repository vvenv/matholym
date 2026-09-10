import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InfoTip extends StatelessWidget {
  const InfoTip(
    this.message, {
    super.key,
    this.icon = Icons.info_outline,
    this.size = 18,
  });

  final String message;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 200),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: size, color: AppColors.muted),
        ),
      ),
    );
  }
}
