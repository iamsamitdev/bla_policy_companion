// lib/features/claim/presentation/pages/claims_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/status_badge.dart';
import '../widgets/file_claim_sheet.dart';

/// หน้าสินไหม — สรุป + ประวัติการยื่น
/// Day 1: ข้อมูล mock static — Day 2 จะดึงจาก API + เพิ่ม "ยื่นสินไหม" จริง (Mutation)
class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GradientHeader(
          title: 'สินไหม',
          subtitle: 'ยื่นและติดตามสถานะคำขอ',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Stat(label: 'คำขอทั้งหมด', value: '4 รายการ'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Stat(
                      label: 'อนุมัติแล้ว',
                      value: '฿20,700',
                      valueColor: AppColors.successFg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppButton.primary(
                label: 'ยื่นสินไหมใหม่',
                icon: HugeIcons.strokeRoundedAdd01,
                onPressed: () => showFileClaimSheet(context),
              ),
              const SizedBox(height: 8),
              const SectionLabel('ประวัติการยื่น'),
              ..._claims.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ClaimCard(c),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Stat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppType.caption),
          const SizedBox(height: 4),
          Text(value, style: AppType.h1.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final _Claim c;
  const _ClaimCard(this.c);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _bg(c.tone),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(icon: c.icon, size: 20, color: _fg(c.tone)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.title, style: AppType.bodyStrong),
                    const SizedBox(height: 2),
                    Text(c.plan, style: AppType.caption),
                  ],
                ),
              ),
              StatusBadge(label: c.statusLabel, tone: c.tone),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${c.ref} · ${c.date}', style: AppType.caption),
              Text('฿${c.amount}', style: AppType.h3),
            ],
          ),
        ],
      ),
    );
  }

  Color _bg(BadgeTone t) => switch (t) {
    BadgeTone.success => AppColors.successBg,
    BadgeTone.pending => AppColors.pendingBg,
    BadgeTone.danger => AppColors.dangerBg,
    _ => AppColors.infoBg,
  };
  Color _fg(BadgeTone t) => switch (t) {
    BadgeTone.success => AppColors.successFg,
    BadgeTone.pending => AppColors.pendingFg,
    BadgeTone.danger => AppColors.dangerFg,
    _ => AppColors.infoText,
  };
}

class _Claim {
  final AppIconData icon;
  final String title;
  final String plan;
  final String statusLabel;
  final BadgeTone tone;
  final String ref;
  final String date;
  final String amount;
  const _Claim(
    this.icon,
    this.title,
    this.plan,
    this.statusLabel,
    this.tone,
    this.ref,
    this.date,
    this.amount,
  );
}

const _claims = [
  _Claim(
    HugeIcons.strokeRoundedCheckmarkCircle02,
    'ค่ารักษาพยาบาล',
    'BLA คุ้มครองสุขภาพ พลัส',
    'อนุมัติแล้ว',
    BadgeTone.success,
    'CLM-48213',
    '12 มิ.ย. 2569',
    '12,500',
  ),
  _Claim(
    HugeIcons.strokeRoundedClock01,
    'ค่าชดเชยรายวัน',
    'BLA ตลอดชีพ มั่นคง 99',
    'กำลังพิจารณา',
    BadgeTone.pending,
    'CLM-47980',
    '3 มิ.ย. 2569',
    '6,000',
  ),
  _Claim(
    HugeIcons.strokeRoundedMoney01,
    'ค่ารักษาพยาบาล',
    'BLA คุ้มครองสุขภาพ พลัส',
    'จ่ายแล้ว',
    BadgeTone.info,
    'CLM-47621',
    '21 พ.ค. 2569',
    '8,200',
  ),
  _Claim(
    HugeIcons.strokeRoundedCancelCircle,
    'ค่ารักษาพยาบาล',
    'BLA บำนาญมั่นคง 60',
    'ไม่อนุมัติ',
    BadgeTone.danger,
    'CLM-47102',
    '8 พ.ค. 2569',
    '3,400',
  ),
];
