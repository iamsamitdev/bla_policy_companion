// lib/features/payment/presentation/pages/payments_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/status_badge.dart';

/// หน้าชำระเบี้ย — บิลครบกำหนด + ช่องทางชำระ + ประวัติการชำระ
/// Day 1: static — Day 2 จะทำประวัติแบบ Pagination (Infinite Scroll) จาก API
class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GradientHeader(
          title: 'ชำระเบี้ย',
          subtitle: 'จ่ายเบี้ยและดูประวัติ',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              // การ์ดบิลครบกำหนด (gradient)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.rLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(AppSpacing.rPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedClock01,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ครบกำหนดอีก 17 วัน',
                            style: AppType.tiny.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'BLA สะสมทรัพย์ 10/5',
                      style: AppType.body.copyWith(color: Colors.white70),
                    ),
                    Text(
                      '฿50,000',
                      style: AppType.display.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'กำหนดชำระ 15 ก.ค. 2569 · BLA-2569-0002',
                      style: AppType.caption.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedCreditCard,
                          size: 18,
                        ),
                        label: const Text('จ่ายตอนนี้'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const SectionLabel('ช่องทางชำระเงิน'),
              _MethodTile(
                icon: HugeIcons.strokeRoundedQrCode,
                title: 'พร้อมเพย์ / QR',
                subtitle: 'ตัดผ่านบัญชีธนาคาร',
                trailing: const StatusBadge(
                  label: 'ค่าเริ่มต้น',
                  tone: BadgeTone.info,
                ),
                selected: true,
              ),
              const SizedBox(height: 10),
              _MethodTile(
                icon: HugeIcons.strokeRoundedCreditCard,
                title: 'บัตรเครดิต ••6789',
                subtitle: 'KBank Visa Platinum',
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.textSubtle,
                ),
              ),
              const SizedBox(height: 10),
              _AddMethod(),
              const SizedBox(height: 8),
              const SectionLabel('ประวัติการชำระ'),
              ..._payments.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PaymentTile(p),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  final AppIconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool selected;
  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.rMd),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppType.bodyStrong),
                Text(subtitle, style: AppType.caption),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _AddMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DottedAddBox(label: 'เพิ่มช่องทางชำระเงิน', onTap: () {});
  }
}

/// กล่องปุ่ม "เพิ่ม" แบบเส้นประ — reusable
class DottedAddBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const DottedAddBox({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.rMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.rMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              size: 18,
              color: AppColors.textMedium,
            ),
            const SizedBox(width: 8),
            Text(label, style: AppType.label),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final _Payment p;
  const _PaymentTile(this.p);

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
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
              size: 20,
              color: AppColors.successFg,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title, style: AppType.bodyStrong),
                Text('${p.date} · ${p.method}', style: AppType.caption),
              ],
            ),
          ),
          Text('฿${p.amount}', style: AppType.h3),
        ],
      ),
    );
  }
}

class _Payment {
  final String title;
  final String date;
  final String method;
  final String amount;
  const _Payment(this.title, this.date, this.method, this.amount);
}

const _payments = [
  _Payment('BLA ตลอดชีพ มั่นคง 99', '1 ม.ค. 2569', 'พร้อมเพย์ / QR', '24,000'),
  _Payment('BLA บำนาญมั่นคง 60', '10 ส.ค. 2568', 'บัตรเครดิต ••6789', '36,000'),
  _Payment(
    'BLA คุ้มครองสุขภาพ พลัส',
    '5 มี.ค. 2568',
    'พร้อมเพย์ / QR',
    '18,500',
  ),
];
