// lib/features/claim/presentation/widgets/file_claim_sheet.dart
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/icons/app_icons.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';

/// แสดง Modal Bottom Sheet "ยื่นสินไหม"
/// เรียกจากหน้าแรก, รายละเอียดกรมธรรม์ และหน้าสินไหม
/// [policyName] = ชื่อกรมธรรม์ที่จะยื่น (แสดงเป็นหัวข้อย่อย ถ้ามี)
Future<void> showFileClaimSheet(BuildContext context, {String? policyName}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FileClaimSheet(policyName: policyName),
  );
}

class FileClaimSheet extends StatefulWidget {
  final String? policyName;
  const FileClaimSheet({super.key, this.policyName});

  @override
  State<FileClaimSheet> createState() => _FileClaimSheetState();
}

class _FileClaimSheetState extends State<FileClaimSheet> {
  final _amount = TextEditingController();
  final _reason = TextEditingController();

  // เลขอ้างอิงหลังยื่นสำเร็จ — ถ้ายังเป็น null แสดงฟอร์ม
  String? _claimRef;

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    final n = 10000 + Random().nextInt(90000);
    setState(() => _claimRef = 'CLM-$n');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // เผื่อพื้นที่ให้คีย์บอร์ดดันเนื้อหาขึ้น (viewInsets) และเผื่อแถบ
    // navigation ของระบบ (padding.bottom) ไม่ให้ปุ่มถูกบดบัง
    final bottomInset = media.viewInsets.bottom + media.padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แถบจับลาก
          Center(
            child: Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.rPill),
              ),
            ),
          ),
          if (_claimRef == null) ..._form() else ..._success(_claimRef!),
        ],
      ),
    );
  }

  // ── ฟอร์มกรอกข้อมูลการยื่นสินไหม ───────────────────────────────
  List<Widget> _form() {
    return [
      Text('ยื่นสินไหม', style: AppType.h2),
      if (widget.policyName != null) ...[
        const SizedBox(height: 2),
        Text(
          widget.policyName!,
          style: AppType.caption.copyWith(color: AppColors.primary),
        ),
      ],
      const SizedBox(height: 16),
      AppTextField(
        label: 'จำนวนเงิน (บาท)',
        hint: '0.00',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _amount,
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'เหตุผล / รายละเอียด',
        hint: 'ระบุสาเหตุและรายละเอียดการยื่นสินไหม...',
        maxLines: 4,
        controller: _reason,
      ),
      const SizedBox(height: 20),
      AppButton.primary(label: 'ยืนยันการยื่น', onPressed: _submit),
    ];
  }

  // ── หน้ายืนยันยื่นสำเร็จ ───────────────────────────────────────
  List<Widget> _success(String ref) {
    return [
      const SizedBox(height: 8),
      Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.successBg,
            shape: BoxShape.circle,
          ),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            size: 40,
            color: AppColors.successFg,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Center(child: Text('ยื่นสินไหมสำเร็จ', style: AppType.h2)),
      const SizedBox(height: 4),
      Center(
        child: Text(
          'เลขอ้างอิงการยื่น',
          style: AppType.caption.copyWith(color: AppColors.textSubtle),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.rMd),
          ),
          child: Text(
            ref,
            style: AppType.h2.copyWith(color: AppColors.primary),
          ),
        ),
      ),
      const SizedBox(height: 20),
      AppButton.primary(
        label: 'ปิด',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }
}
