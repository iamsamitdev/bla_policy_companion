// lib/features/auth/presentation/pages/reset_password_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/info_hint.dart';

/// หน้าตั้งรหัสผ่านใหม่ (Day 1: UI อย่างเดียว)
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientHeader(
            showBack: true,
            title: 'ตั้งรหัสผ่านใหม่',
            subtitle: 'สร้างรหัสผ่านใหม่สำหรับบัญชีของคุณ',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSecurityCheck,
                      size: 34,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const AppTextField(
                  label: 'รหัสผ่านใหม่',
                  hint: 'อย่างน้อย 8 ตัวอักษร',
                  icon: HugeIcons.strokeRoundedSquareLock01,
                  obscure: true,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'ยืนยันรหัสผ่านใหม่',
                  hint: 'พิมพ์รหัสผ่านอีกครั้ง',
                  icon: HugeIcons.strokeRoundedSquareLock01,
                  obscure: true,
                ),
                const SizedBox(height: 12),
                const InfoHint(
                  'ใช้อย่างน้อย 8 ตัวอักษร ประกอบด้วยตัวอักษรและตัวเลข',
                ),
                const SizedBox(height: 18),
                AppButton.primary(
                  label: 'ตั้งรหัสผ่านใหม่',
                  icon: HugeIcons.strokeRoundedSecurityCheck,
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
