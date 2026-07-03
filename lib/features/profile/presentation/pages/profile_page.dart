// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// หน้าโปรไฟล์ — ข้อมูลผู้ใช้ + เมนูบัญชี + การตั้งค่า
/// Day 1: UI static + toggle เป็น local state — Day 3 จะต่อ Secure Storage / โหมดมืดจริง
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _noti = true;
  bool _dark = false;
  bool _thai = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientHeader(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage('assets/images/bla_avatar.png'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'คุณสมชาย ใจดี',
                      style: AppType.h2.copyWith(color: Colors.white),
                    ),
                    Text(
                      'ตัวแทน BLA · รหัส agent',
                      style: AppType.caption.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(AppSpacing.rPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ยืนยันตัวตนแล้ว',
                            style: AppType.tiny.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const CircleHeaderButton(icon: HugeIcons.strokeRoundedEdit02),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              const SectionLabel('บัญชีของฉัน'),
              _MenuGroup(
                items: [
                  _MenuItem(HugeIcons.strokeRoundedUser, 'ข้อมูลส่วนตัว'),
                  _MenuItem(HugeIcons.strokeRoundedShield01, 'กรมธรรม์ของฉัน'),
                  _MenuItem(HugeIcons.strokeRoundedClock01, 'ประวัติการชำระ'),
                ],
              ),
              const SectionLabel('การตั้งค่า'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _ToggleRow(
                      icon: HugeIcons.strokeRoundedNotification02,
                      label: 'การแจ้งเตือน',
                      value: _noti,
                      onChanged: (v) => setState(() => _noti = v),
                    ),
                    const Divider(height: 1),
                    _NavRow(
                      icon: HugeIcons.strokeRoundedSquareLock01,
                      label: 'ความปลอดภัย',
                    ),
                    const Divider(height: 1),
                    _SegmentRow(
                      icon: HugeIcons.strokeRoundedGlobe02,
                      label: 'ภาษา',
                      isThai: _thai,
                      onChanged: (v) => setState(() => _thai = v),
                    ),
                    const Divider(height: 1),
                    _ToggleRow(
                      icon: HugeIcons.strokeRoundedMoon02,
                      label: 'โหมดมืด',
                      value: _dark,
                      onChanged: (v) => setState(() => _dark = v),
                    ),
                  ],
                ),
              ),
              const SectionLabel('ช่วยเหลือ'),
              _MenuGroup(
                items: [
                  _MenuItem(
                    HugeIcons.strokeRoundedCustomerService01,
                    'ติดต่อตัวแทน',
                  ),
                  _MenuItem(
                    HugeIcons.strokeRoundedHelpCircle,
                    'คำถามที่พบบ่อย',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LogoutButton(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'BLA Policy Companion · v1.0.0',
                  style: AppType.caption.copyWith(color: AppColors.textSubtle),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuGroup({required this.items});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _NavRow(icon: items[i].icon, label: items[i].label),
            if (i != items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _MenuItem {
  final AppIconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}

/// ปุ่มออกจากระบบ — สไตล์ danger (พื้นแดงอ่อน ตัวอักษร/ไอคอนสีแดง)
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerBg,
      borderRadius: BorderRadius.circular(AppSpacing.rMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.rMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout01,
                size: 20,
                color: AppColors.dangerFg,
              ),
              const SizedBox(width: 8),
              Text(
                'ออกจากระบบ',
                style: AppType.bodyStrong.copyWith(color: AppColors.dangerFg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final AppIconData icon;
  final String label;
  const _NavRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: HugeIcon(icon: icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppType.bodyStrong),
      trailing: const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.textSubtle,
      ),
      onTap: () {},
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final AppIconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: HugeIcon(icon: icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppType.bodyStrong),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _SegmentRow extends StatelessWidget {
  final AppIconData icon;
  final String label;
  final bool isThai;
  final ValueChanged<bool> onChanged;
  const _SegmentRow({
    required this.icon,
    required this.label,
    required this.isThai,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: HugeIcon(icon: icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppType.bodyStrong),
      trailing: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.rPill),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _seg('ไทย', isThai, () => onChanged(true)),
            _seg('EN', !isThai, () => onChanged(false)),
          ],
        ),
      ),
    );
  }

  Widget _seg(String t, bool on, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: on ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.rPill),
        ),
        child: Text(
          t,
          style: AppType.tiny.copyWith(
            color: on ? Colors.white : AppColors.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
