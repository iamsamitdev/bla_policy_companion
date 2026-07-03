// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/info_hint.dart';
import '../../../app/main_shell.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

/// หน้าเข้าสู่ระบบ
/// Day 1: เป็น UI ครบตาม mockup — ปุ่ม "เข้าสู่ระบบ" พาเข้าแอปเลย (ยังไม่ตรวจรหัสจริง)
/// Day 3: จะต่อ Reactive Auth + Secure Storage + Route Guard จริง
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _enter(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // หัว gradient + โลโก้
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.rLg),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                child: Column(
                  children: [
                    const AppLogo(size: 76),
                    const SizedBox(height: 14),
                    Text(
                      'เข้าสู่ระบบเพื่อจัดการกรมธรรม์ของคุณ',
                      textAlign: TextAlign.center,
                      style: AppType.body.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppTextField(
                  label: 'ชื่อผู้ใช้',
                  hint: 'agent',
                  icon: HugeIcons.strokeRoundedUser,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'รหัสผ่าน',
                  hint: '••••',
                  icon: HugeIcons.strokeRoundedSquareLock01,
                  obscure: true,
                ),
                const SizedBox(height: 12),
                const InfoHint('บัญชีทดสอบ: ชื่อผู้ใช้ agent / รหัสผ่าน 1234'),
                const SizedBox(height: 18),
                AppButton.primary(
                  label: 'เข้าสู่ระบบ',
                  icon: HugeIcons.strokeRoundedLogin03,
                  onPressed: () => _enter(context),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    ),
                    child: Text(
                      'ลืมรหัสผ่าน?',
                      style: AppType.bodyStrong.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const _OrDivider(label: 'หรือดำเนินการต่อด้วย'),
                const SizedBox(height: 16),
                AppButton.social(
                  label: 'ดำเนินการต่อด้วย Google',
                  icon: HugeIcons.strokeRoundedGoogle,
                  color: const Color(0xFF4285F4),
                  onPressed: () => _enter(context),
                ),
                const SizedBox(height: 12),
                AppButton.social(
                  label: 'ดำเนินการต่อด้วย LINE',
                  icon: HugeIcons.strokeRoundedBubbleChat,
                  color: const Color(0xFF06C755),
                  onPressed: () => _enter(context),
                ),
                const _OrDivider(label: 'ยังไม่มีบัญชี?'),
                const SizedBox(height: 16),
                AppButton.secondary(
                  label: 'สมัครสมาชิก',
                  icon: HugeIcons.strokeRoundedUserAdd01,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'กรุงเทพประกันชีวิต จำกัด (มหาชน) · v1.0.0',
                    style: AppType.caption,
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

/// เส้นคั่นพร้อมข้อความตรงกลาง (— หรือ —)
class _OrDivider extends StatelessWidget {
  final String label;
  const _OrDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: AppType.caption),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
