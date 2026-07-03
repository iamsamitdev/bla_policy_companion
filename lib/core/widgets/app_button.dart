// lib/core/widgets/app_button.dart
import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// ปุ่มของ Design System — รองรับหลายแบบด้วย named constructors
/// เพื่อให้ทั้งแอปใช้ปุ่มหน้าตาเดียวกัน
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppIconData? icon;
  final _ButtonKind _kind;
  final Color? customColor;
  final bool expand;

  const AppButton._(
    this._kind, {
    required this.label,
    required this.onPressed,
    this.icon,
    this.customColor,
    this.expand = true,
  });

  /// ปุ่มหลัก (gradient น้ำเงิน)
  const AppButton.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppIconData? icon,
    bool expand = true,
  }) : this._(
         _ButtonKind.primary,
         label: label,
         onPressed: onPressed,
         icon: icon,
         expand: expand,
       );

  /// ปุ่มรอง (ขอบ + พื้นขาว)
  const AppButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppIconData? icon,
    bool expand = true,
  }) : this._(
         _ButtonKind.secondary,
         label: label,
         onPressed: onPressed,
         icon: icon,
         expand: expand,
       );

  /// ปุ่ม social (Google/LINE) — ส่งสีพื้นได้
  const AppButton.social({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppIconData? icon,
    Color? color,
    bool expand = true,
  }) : this._(
         _ButtonKind.social,
         label: label,
         onPressed: onPressed,
         icon: icon,
         customColor: color,
         expand: expand,
       );

  @override
  Widget build(BuildContext context) {
    final child = _content();
    final button = switch (_kind) {
      _ButtonKind.primary => _gradientButton(child),
      _ButtonKind.secondary => _outlinedButton(child),
      _ButtonKind.social => _socialButton(child),
    };
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _content() {
    final color = switch (_kind) {
      _ButtonKind.primary => Colors.white,
      _ButtonKind.secondary => AppColors.primary,
      _ButtonKind.social =>
        customColor == null ? AppColors.textDark : Colors.white,
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          HugeIcon(icon: icon!, size: 20, color: color),
          const SizedBox(width: 8),
        ],
        Text(label, style: AppType.bodyStrong.copyWith(color: color)),
      ],
    );
  }

  Widget _gradientButton(Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: onPressed == null ? null : AppColors.primaryGradient,
        color: onPressed == null ? AppColors.textSubtle : null,
        borderRadius: BorderRadius.circular(AppSpacing.rMd),
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.rMd),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _outlinedButton(Widget child) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.rMd),
        ),
      ),
      child: child,
    );
  }

  Widget _socialButton(Widget child) {
    final bg = customColor ?? AppColors.card;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.rMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.rMd),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.rMd),
            border: customColor == null
                ? Border.all(color: AppColors.border, width: 1.4)
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: child,
        ),
      ),
    );
  }
}

enum _ButtonKind { primary, secondary, social }
