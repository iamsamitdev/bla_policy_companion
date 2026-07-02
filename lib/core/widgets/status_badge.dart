// lib/core/widgets/status_badge.dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// โทนสีของ badge สถานะ
enum BadgeTone { success, pending, danger, info, neutral }

/// ป้ายสถานะ (เช่น มีผลบังคับ / รอดำเนินการ / ขาดอายุ / อนุมัติ)
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeTone tone;

  const StatusBadge({super.key, required this.label, required this.tone});

  ({Color bg, Color fg}) get _colors {
    switch (tone) {
      case BadgeTone.success:
        return (bg: AppColors.successBg, fg: AppColors.successText);
      case BadgeTone.pending:
        return (bg: AppColors.pendingBg, fg: AppColors.pendingText);
      case BadgeTone.danger:
        return (bg: AppColors.dangerBg, fg: AppColors.dangerText);
      case BadgeTone.info:
        return (bg: AppColors.infoBg, fg: AppColors.infoText);
      case BadgeTone.neutral:
        return (bg: AppColors.background, fg: AppColors.textMedium);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(AppSpacing.rPill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: c.fg,
        ),
      ),
    );
  }
}
