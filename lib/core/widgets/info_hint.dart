// lib/core/widgets/info_hint.dart
import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// กล่องคำใบ้/หมายเหตุเล็ก ๆ (เช่น "บัญชีทดสอบ: ...", เคล็ดลับรหัสผ่าน)
class InfoHint extends StatelessWidget {
  final String text;
  final AppIconData icon;
  const InfoHint(
    this.text, {
    super.key,
    this.icon = HugeIcons.strokeRoundedIdea,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.rSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, size: 16, color: AppColors.textSubtle),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppType.caption)),
        ],
      ),
    );
  }
}
