// lib/core/widgets/gradient_header.dart
import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// หัวหน้าจอพื้น gradient น้ำเงิน มุมล่างโค้ง — ใช้ซ้ำเกือบทุกหน้า
class GradientHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final Widget? leading;
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const GradientHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
    this.leading,
    this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.rLg),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack || leading != null || trailing != null)
                Row(
                  children: [
                    if (showBack)
                      _CircleIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    if (leading != null) ...[
                      if (showBack) const SizedBox(width: 10),
                      leading!,
                    ],
                    const Spacer(),
                    if (trailing != null) trailing!,
                  ],
                ),
              if (title != null) ...[
                if (showBack || leading != null || trailing != null)
                  const SizedBox(height: 12),
                Text(title!, style: AppType.h1.copyWith(color: Colors.white)),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppType.body.copyWith(color: Colors.white70),
                ),
              ],
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final AppIconData icon;
  final VoidCallback? onTap;
  const _CircleIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: HugeIcon(icon: icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
