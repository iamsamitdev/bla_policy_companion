// lib/features/auth/presentation/pages/forgot_password_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_header.dart';
import 'reset_password_page.dart';

/// หน้าลืมรหัสผ่าน — กรอกอีเมลเพื่อรับลิงก์รีเซ็ต (Day 1: UI อย่างเดียว)
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientHeader(
            showBack: true,
            title: 'ลืมรหัสผ่าน',
            subtitle:
                'กรอกอีเมลที่ลงทะเบียนไว้ เราจะส่งลิงก์รีเซ็ตรหัสผ่านให้คุณ',
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
                      icon: HugeIcons.strokeRoundedLockKey,
                      size: 34,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const AppTextField(
                  label: 'อีเมล',
                  hint: 'you@example.com',
                  icon: HugeIcons.strokeRoundedMail01,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                AppButton.primary(
                  label: 'ส่งลิงก์รีเซ็ต',
                  icon: HugeIcons.strokeRoundedMail01,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      size: 18,
                    ),
                    label: const Text('กลับไปหน้าเข้าสู่ระบบ'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
