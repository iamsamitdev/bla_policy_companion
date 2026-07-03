// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../app/main_shell.dart';
import '../../../claim/presentation/widgets/file_claim_sheet.dart';

/// หน้าแรก (Dashboard) — สรุปวงเงิน, เบี้ยครบกำหนด, ปุ่มลัด, การแจ้งเตือน
/// Day 1: ข้อมูล mock แบบ static — Day 2 จะดึงจาก API จริง
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 70),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  backgroundImage: AssetImage('assets/images/bla_avatar.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สวัสดี 👋',
                        style: AppType.caption.copyWith(color: Colors.white70),
                      ),
                      Text(
                        'คุณสมชาย ใจดี',
                        style: AppType.h2.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const CircleHeaderButton(
                  icon: HugeIcons.strokeRoundedNotification02,
                ),
              ],
            ),
          ),
        ),
        // การ์ดสรุป ซ้อนทับขึ้นมาบน header
        Transform.translate(
          offset: const Offset(0, -52),
          child: Padding(
            padding: AppSpacing.pageH,
            child: Column(
              children: [
                _SummaryCard(),
                const SizedBox(height: 14),
                _DuePremiumCard(),
                const SizedBox(height: 18),
                const _QuickActions(),
                const SizedBox(height: 8),
                SectionLabel(
                  'การแจ้งเตือนล่าสุด',
                  trailing: Text(
                    'ดูทั้งหมด',
                    style: AppType.label.copyWith(color: AppColors.primary),
                  ),
                ),
                ..._notifications.map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NotificationTile(n),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('วงเงินคุ้มครองรวม', style: AppType.label),
          const SizedBox(height: 4),
          Text('฿1,250,000', style: AppType.display),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _MiniStat(label: 'กรมธรรม์มีผลบังคับ', value: '2 ฉบับ'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniStat(label: 'เบี้ยรวม/ปี', value: '฿60,000'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.rSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppType.caption),
          const SizedBox(height: 4),
          Text(value, style: AppType.h3),
        ],
      ),
    );
  }
}

class _DuePremiumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.rMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar03,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เบี้ยครบกำหนด ฿50,000',
                  style: AppType.bodyStrong.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  'BLA สะสมทรัพย์ 10/5 · 15 ก.ค. 2569',
                  style: AppType.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('ชำระ'),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = <({AppIconData icon, String label, VoidCallback onTap})>[
      (
        icon: HugeIcons.strokeRoundedCreditCard,
        label: 'ชำระเบี้ย',
        onTap: () => ref.read(mainTabProvider.notifier).state = 3,
      ),
      (
        icon: HugeIcons.strokeRoundedNoteAdd,
        label: 'ยื่นสินไหม',
        onTap: () => showFileClaimSheet(context),
      ),
      (
        icon: HugeIcons.strokeRoundedShield01,
        label: 'กรมธรรม์',
        onTap: () => ref.read(mainTabProvider.notifier).state = 1,
      ),
      (
        icon: HugeIcons.strokeRoundedCustomerService01,
        label: 'ติดต่อเรา',
        onTap: () {},
      ),
    ];
    return Row(
      children: [
        for (final a in actions)
          Expanded(
            child: GestureDetector(
              onTap: a.onTap,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.rMd),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F1855A3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0x141855A3),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: HugeIcon(
                        icon: a.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      a.label,
                      style: AppType.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _Noti n;
  const _NotificationTile(this.n);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: n.tone == BadgeTone.success
                  ? AppColors.successBg
                  : n.tone == BadgeTone.info
                  ? AppColors.infoBg
                  : AppColors.pendingBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: HugeIcon(icon: n.icon, size: 20, color: _iconColor(n.tone)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.title, style: AppType.bodyStrong),
                const SizedBox(height: 2),
                Text(n.subtitle, style: AppType.caption),
              ],
            ),
          ),
          Text(n.time, style: AppType.tiny),
        ],
      ),
    );
  }

  Color _iconColor(BadgeTone t) => switch (t) {
    BadgeTone.success => AppColors.successFg,
    BadgeTone.info => AppColors.infoText,
    _ => AppColors.pendingFg,
  };
}

class _Noti {
  final AppIconData icon;
  final String title;
  final String subtitle;
  final String time;
  final BadgeTone tone;
  const _Noti(this.icon, this.title, this.subtitle, this.time, this.tone);
}

const _notifications = [
  _Noti(
    HugeIcons.strokeRoundedCreditCard,
    'เบี้ยใกล้ครบกำหนด',
    'BLA สะสมทรัพย์ 10/5 · ฿50,000',
    'อีก 17 วัน',
    BadgeTone.info,
  ),
  _Noti(
    HugeIcons.strokeRoundedCheckmarkCircle02,
    'สินไหมอนุมัติแล้ว',
    'CLM-48213 · ค่ารักษาพยาบาล',
    '2 วันที่แล้ว',
    BadgeTone.success,
  ),
  _Noti(
    HugeIcons.strokeRoundedShield01,
    'กรมธรรม์มีผลบังคับ',
    'BLA ตลอดชีพ มั่นคง 99',
    '1 สัปดาห์ที่แล้ว',
    BadgeTone.success,
  ),
];
