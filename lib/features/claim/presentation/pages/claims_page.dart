// lib/features/claim/presentation/pages/claims_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/claim_repository.dart';
import '../../domain/claim_record.dart';
import '../widgets/file_claim_sheet.dart';

/// แปลงสถานะสินไหม → โทนสี + ไอคอน (กฎการแสดงผลรวมไว้ที่เดียว)
BadgeTone claimTone(ClaimStatus s) => switch (s) {
  ClaimStatus.approved => BadgeTone.success,
  ClaimStatus.reviewing => BadgeTone.pending,
  ClaimStatus.submitted => BadgeTone.info,
  ClaimStatus.rejected => BadgeTone.danger,
};

AppIconData claimIcon(ClaimStatus s) => switch (s) {
  ClaimStatus.approved => HugeIcons.strokeRoundedCheckmarkCircle02,
  ClaimStatus.reviewing => HugeIcons.strokeRoundedClock01,
  ClaimStatus.submitted => HugeIcons.strokeRoundedNoteAdd,
  ClaimStatus.rejected => HugeIcons.strokeRoundedCancelCircle,
};

/// หน้าสินไหม — สรุป + ประวัติการยื่น (Day 2: ดึงจาก API จริง)
class ClaimsPage extends ConsumerWidget {
  const ClaimsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncClaims = ref.watch(claimListProvider);
    final claims = asyncClaims.value ?? const <ClaimRecord>[];

    final approvedSum = claims
        .where((c) => c.status == ClaimStatus.approved)
        .fold<double>(0, (s, c) => s + c.amount);

    return Column(
      children: [
        GradientHeader(
          title: 'สินไหม',
          subtitle: 'ยื่นและติดตามสถานะคำขอ',
          trailing: const CircleHeaderButton(
            icon: HugeIcons.strokeRoundedNotification02,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(claimListProvider),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: 'คำขอทั้งหมด',
                        value: '${claims.length} รายการ',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(
                        label: 'อนุมัติแล้ว',
                        value: '฿${money(approvedSum)}',
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
                ...asyncClaims.when(
                  loading: () => List.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Skeletonizer(child: _ClaimCard(_fakeClaim)),
                    ),
                  ),
                  error: (e, _) => [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(child: Text('โหลดสินไหมไม่สำเร็จ: $e')),
                    ),
                  ],
                  data: (list) => list.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Center(
                              child: Text('ยังไม่มีประวัติการยื่น'),
                            ),
                          ),
                        ]
                      : list
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ClaimCard(c),
                              ),
                            )
                            .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final _fakeClaim = ClaimRecord(
  claimRef: 'CLM-000000',
  policyNumber: 'BLA-2569-0000',
  amount: 0,
  status: ClaimStatus.approved,
  submittedAt: DateTime(2569),
);

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
  final ClaimRecord c;
  const _ClaimCard(this.c);

  @override
  Widget build(BuildContext context) {
    final tone = claimTone(c.status);
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _bg(tone),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(
                  icon: claimIcon(c.status),
                  size: 20,
                  color: _fg(tone),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('คำขอสินไหม', style: AppType.bodyStrong),
                    const SizedBox(height: 2),
                    Text(c.policyNumber, style: AppType.caption),
                  ],
                ),
              ),
              StatusBadge(label: c.status.label, tone: tone),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${c.claimRef} · ${thaiDate(c.submittedAt)}',
                  style: AppType.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '฿${money(c.amount)}',
                  style: AppType.h3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
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
