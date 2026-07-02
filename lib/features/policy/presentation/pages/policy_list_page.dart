// lib/features/policy/presentation/pages/policy_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/policy.dart';
import '../controllers/policy_list_controller.dart';

/// แปลงสถานะกรมธรรม์ → โทนสีของ badge (กฎการแสดงผลรวมไว้ที่เดียว)
BadgeTone toneOf(PolicyStatus s) => switch (s) {
  PolicyStatus.active => BadgeTone.success,
  PolicyStatus.pending => BadgeTone.pending,
  PolicyStatus.lapsed => BadgeTone.danger,
};

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPolicies = ref.watch(policyListProvider);
    final policies = ref.watch(filteredPolicyListProvider);
    final selected = ref.watch(policyStatusFilterProvider);
    final total = asyncPolicies.value?.length ?? 0;

    final activePremium = (asyncPolicies.value ?? [])
        .where((p) => p.status == PolicyStatus.active)
        .fold<double>(0, (s, p) => s + p.premium);

    return Column(
      children: [
        GradientHeader(
          title: 'กรมธรรม์ของฉัน',
          subtitle: 'ทั้งหมด $total ฉบับ',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              // ช่องค้นหา
              TextField(
                onChanged: (v) =>
                    ref.read(policySearchProvider.notifier).update(v),
                decoration: const InputDecoration(
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: AppColors.textSubtle,
                  ),
                  hintText: 'ค้นหาชื่อแผน หรือ เลขที่กรมธรรม์',
                ),
              ),
              const SizedBox(height: 12),
              // แถบกรองสถานะ
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _Chip(
                      label: 'ทั้งหมด',
                      selected: selected == null,
                      onTap: () => ref
                          .read(policyStatusFilterProvider.notifier)
                          .select(null),
                    ),
                    for (final s in PolicyStatus.values)
                      _Chip(
                        label: s.label,
                        selected: selected == s,
                        onTap: () => ref
                            .read(policyStatusFilterProvider.notifier)
                            .select(s),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // แถบเบี้ยรวม
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(AppSpacing.rSm),
                ),
                child: Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedWallet01,
                      size: 18,
                      color: AppColors.infoText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'เบี้ยรวม (มีผลบังคับ)',
                      style: AppType.label.copyWith(color: AppColors.infoText),
                    ),
                    const Spacer(),
                    Text(
                      '฿${activePremium.toStringAsFixed(0)}/ปี',
                      style: AppType.bodyStrong.copyWith(
                        color: AppColors.infoText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // เนื้อหา: loading / error / data
              ...asyncPolicies.when(
                loading: () => [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
                error: (e, _) => [Center(child: Text('เกิดข้อผิดพลาด: $e'))],
                data: (_) => policies.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text('ไม่พบกรมธรรม์ที่ตรงเงื่อนไข'),
                          ),
                        ),
                      ]
                    : policies
                          .map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PolicyCard(policy: p),
                            ),
                          )
                          .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(AppSpacing.rPill),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppType.label.copyWith(
              color: selected ? Colors.white : AppColors.textMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final Policy policy;
  const _PolicyCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    final tone = toneOf(policy.status);
    final iconColor = switch (tone) {
      BadgeTone.success => AppColors.successFg,
      BadgeTone.pending => AppColors.pendingFg,
      BadgeTone.danger => AppColors.dangerFg,
      _ => AppColors.primary,
    };
    final iconBg = switch (tone) {
      BadgeTone.success => AppColors.successBg,
      BadgeTone.pending => AppColors.pendingBg,
      BadgeTone.danger => AppColors.dangerBg,
      _ => AppColors.background,
    };
    return AppCard(
      padding: const EdgeInsets.all(14),
      // โปรเจกต์จริง (branch day1) เปิดหน้า PolicyDetailPage แทน — ในเวิร์กช็อปนี้ใช้ SnackBar ให้รันได้ทันที
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เปิดกรมธรรม์ ${policy.policyNumber}')),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedShield01,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(policy.planName, style: AppType.title),
                const SizedBox(height: 2),
                Text(policy.policyNumber, style: AppType.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '฿${policy.premium.toStringAsFixed(0)}/ปี',
                      style: AppType.bodyStrong,
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(label: policy.status.label, tone: tone),
                  ],
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSubtle,
          ),
        ],
      ),
    );
  }
}
