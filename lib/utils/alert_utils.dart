import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AlertType { success, error, info, warning }

IconData _iconFor(AlertType t) {
  switch (t) {
    case AlertType.success:
      return Icons.check_circle_rounded;
    case AlertType.error:
      return Icons.cancel_rounded;
    case AlertType.info:
      return Icons.info_rounded;
    case AlertType.warning:
      return Icons.warning_amber_rounded;
  }
}

Color _bgFor(AlertType t) {
  switch (t) {
    case AlertType.success:
      return AppTheme.successGreen;
    case AlertType.error:
      return AppTheme.errorRed;
    case AlertType.info:
      return AppTheme.infoBlue;
    case AlertType.warning:
      return AppTheme.warningYellow;
  }
}

void showSidianAlert(
    BuildContext context, {
      required String message,
      required AlertType type,
      Duration duration = const Duration(seconds: 3),
    }) {
  final bg = _bgFor(type);
  final bool useDarkText = type == AlertType.warning;
  final Color textColor = useDarkText ? AppTheme.textPrimary : Colors.white;

  final snack = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    duration: duration,
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(_iconFor(type), size: 22, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Calibri',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  messenger.showSnackBar(snack);
}
