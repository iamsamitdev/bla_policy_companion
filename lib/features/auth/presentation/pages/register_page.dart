// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_header.dart';

/// หน้าสมัครสมาชิก — UI ครบตาม mockup (Day 1 ยังไม่ส่งข้อมูลจริง)
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _accept = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientHeader(
            showBack: true,
            title: 'สมัครสมาชิก',
            subtitle: 'กรอกข้อมูลเพื่อเปิดบัญชีใหม่',
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 28 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppTextField(
                  label: 'ชื่อ-นามสกุล',
                  hint: 'เช่น สมชาย ใจดี',
                  icon: HugeIcons.strokeRoundedUser,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'อีเมล',
                  hint: 'you@example.com',
                  icon: HugeIcons.strokeRoundedMail01,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'เบอร์โทรศัพท์',
                  hint: '08X-XXX-XXXX',
                  icon: HugeIcons.strokeRoundedCall,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'รหัสผ่าน',
                  hint: 'อย่างน้อย 8 ตัวอักษร',
                  icon: HugeIcons.strokeRoundedSquareLock01,
                  obscure: true,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'ยืนยันรหัสผ่าน',
                  hint: 'พิมพ์รหัสผ่านอีกครั้ง',
                  icon: HugeIcons.strokeRoundedSquareLock01,
                  obscure: true,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Checkbox(
                      value: _accept,
                      onChanged: (v) => setState(() => _accept = v ?? false),
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: AppType.caption,
                          children: const [
                            TextSpan(text: 'ฉันยอมรับ '),
                            TextSpan(
                              text: 'ข้อกำหนดและนโยบายความเป็นส่วนตัว',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppButton.primary(
                  label: 'สร้างบัญชี',
                  icon: HugeIcons.strokeRoundedUserAdd01,
                  onPressed: _accept ? () => Navigator.of(context).pop() : null,
                ),
                const SizedBox(height: 16),
                AppButton.social(
                  label: 'ดำเนินการต่อด้วย Google',
                  icon: HugeIcons.strokeRoundedGoogle,
                  color: const Color(0xFF4285F4),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                AppButton.social(
                  label: 'ดำเนินการต่อด้วย LINE',
                  icon: HugeIcons.strokeRoundedBubbleChat,
                  color: const Color(0xFF06C755),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
