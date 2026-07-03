// lib/features/payment/presentation/pages/payments_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/payment.dart';
import '../controllers/payment_history_controller.dart';

/// หน้าชำระเบี้ย — บิลครบกำหนด + ช่องทางชำระ + ประวัติการชำระ
/// Day 2: ประวัติการชำระเป็น Pagination / Infinite Scroll จาก API จริง
class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  // เลื่อนใกล้ท้าย list → โหลดหน้าถัดไป (Infinite Scroll)
  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      ref.read(paymentHistoryControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(paymentHistoryControllerProvider);
    final hasMore = ref.read(paymentHistoryControllerProvider.notifier).hasMore;

    return Column(
      children: [
        const GradientHeader(
          title: 'ชำระเบี้ย',
          subtitle: 'จ่ายเบี้ยและดูประวัติ',
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(paymentHistoryControllerProvider.notifier).refresh(),
            child: ListView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                _DueCard(),
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
                DottedAddBox(label: 'เพิ่มช่องทางชำระเงิน', onTap: () {}),
                const SizedBox(height: 8),
                const SectionLabel('ประวัติการชำระ'),
                // ประวัติ: loading (skeleton) / error / data + ตัวโหลดท้าย list
                ...async.when(
                  loading: () => List.generate(
                    5,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Skeletonizer(child: _PaymentTile(_fakePayment)),
                    ),
                  ),
                  error: (e, _) => [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(child: Text('โหลดประวัติไม่สำเร็จ: $e')),
                    ),
                  ],
                  data: (list) => [
                    ...list.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PaymentTile(p),
                      ),
                    ),
                    if (hasMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final _fakePayment = Payment(
  id: 'PMT-0000',
  title: 'ชำระเบี้ยงวดที่ 0',
  amount: 0,
  paidAt: DateTime(2569),
);

class _DueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.rLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          Text('฿50,000', style: AppType.display.copyWith(color: Colors.white)),
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
  final Payment p;
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
                Text(thaiDate(p.paidAt), style: AppType.caption),
              ],
            ),
          ),
          Text('฿${money(p.amount)}', style: AppType.h3),
        ],
      ),
    );
  }
}
