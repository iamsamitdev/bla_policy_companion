// lib/features/policy/presentation/pages/policy_detail_page.dart
import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../claim/presentation/widgets/file_claim_sheet.dart';
import '../../domain/policy.dart';

/// หน้ารายละเอียดกรมธรรม์
/// Day 1: รับ Policy ที่ส่งมาแล้วแสดงผล (ข้อมูลคงที่บางส่วนเป็น mock)
/// Day 2: จะดึงรายละเอียดเต็มจาก API ตาม id
class PolicyDetailPage extends StatelessWidget {
  final Policy policy;
  const PolicyDetailPage({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'รายละเอียดกรมธรรม์',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // การ์ดหัว gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.circular(AppSpacing.rLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniBadge(label: policy.status.label, status: policy.status),
                const SizedBox(height: 12),
                Text(
                  policy.planName,
                  style: AppType.h2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  policy.policyNumber,
                  style: AppType.caption.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.rMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วงเงินคุ้มครอง',
                        style: AppType.caption.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '฿500,000',
                        style: AppType.display.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ข้อมูลกรมธรรม์', style: AppType.h3),
                ),
                const SizedBox(height: 8),
                const Divider(),
                _row('ผู้เอาประกัน', 'นายสมชาย ใจดี'),
                _row('เบี้ยประกัน', '฿${policy.premium.toStringAsFixed(0)}/ปี'),
                _row('วันเริ่มสัญญา', '1 ม.ค. 2565'),
                _row('วันสิ้นสุด', '1 ม.ค. 2664'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: 'ชำระเบี้ย',
                  icon: HugeIcons.strokeRoundedCreditCard,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  label: 'ยื่นสินไหม',
                  icon: HugeIcons.strokeRoundedNoteAdd,
                  onPressed: () => showFileClaimSheet(
                    context,
                    policyId: policy.id,
                    policyName: policy.planName,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppType.body),
          Text(value, style: AppType.bodyStrong),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final PolicyStatus status;
  const _MiniBadge({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.rPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppType.tiny.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
