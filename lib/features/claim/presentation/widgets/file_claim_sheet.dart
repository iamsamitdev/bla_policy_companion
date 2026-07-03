// lib/features/claim/presentation/widgets/file_claim_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/claim_controller.dart';

/// แสดง Modal Bottom Sheet "ยื่นสินไหม"
/// เรียกจากหน้าแรก, รายละเอียดกรมธรรม์ และหน้าสินไหม
/// [policyId] = กรมธรรม์ที่จะยื่น (จำเป็นต่อการยื่นผ่าน API), [policyName] = ชื่อแสดงผล
Future<void> showFileClaimSheet(
  BuildContext context, {
  String? policyId,
  String? policyName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FileClaimSheet(policyId: policyId, policyName: policyName),
  );
}

class FileClaimSheet extends ConsumerStatefulWidget {
  final String? policyId;
  final String? policyName;
  const FileClaimSheet({super.key, this.policyId, this.policyName});

  @override
  ConsumerState<FileClaimSheet> createState() => _FileClaimSheetState();
}

class _FileClaimSheetState extends ConsumerState<FileClaimSheet> {
  final _amount = TextEditingController();
  final _reason = TextEditingController();

  bool _submitting = false;

  // เลขอ้างอิงหลังยื่นสำเร็จ — ถ้ายังเป็น null แสดงฟอร์ม
  String? _claimRef;

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  /// ยื่นสินไหมจริงผ่าน API (POST /policies/:id/claims) ด้วย ClaimController
  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim()) ?? 0;
    if (amount <= 0) {
      _toast('กรุณากรอกจำนวนเงินให้มากกว่า 0');
      return;
    }
    setState(() => _submitting = true);

    // Day 2: ถ้าเปิดจากหน้าสินไหมรวม (ไม่ระบุกรมธรรม์) ใช้ค่าเริ่มต้น P001 เพื่อสาธิต
    // ผลลัพธ์ (สำเร็จ/พลาด) จะถูกจัดการผ่าน ref.listen ใน build() แทนการอ่าน state ตรงนี้
    // เพราะ claimControllerProvider เป็น autoDispose — ถ้าไม่มีใคร watch/listen อยู่
    // มันอาจถูก dispose ไปก่อนที่เราจะอ่านผลลัพธ์ทัน
    await ref
        .read(claimControllerProvider.notifier)
        .submit(
          policyId: widget.policyId ?? 'P001',
          amount: amount,
          reason: _reason.text.trim(),
        );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // ต้อง listen provider นี้ระหว่างที่ sheet ยังเปิดอยู่ ไม่งั้น autoDispose
    // จะเคลียร์ผลลัพธ์ทิ้งก่อนที่ UI จะทันแสดงหน้า success
    ref.listen<AsyncValue<String?>>(claimControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (claimRef) {
          if (claimRef == null) return;
          setState(() {
            _submitting = false;
            _claimRef = claimRef;
          });
        },
        error: (e, _) {
          setState(() => _submitting = false);
          _toast('ยื่นไม่สำเร็จ: $e');
        },
      );
    });

    final media = MediaQuery.of(context);
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
      AppButton.primary(
        label: _submitting ? 'กำลังยื่น...' : 'ยืนยันการยื่น',
        onPressed: _submitting ? null : _submit,
      ),
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
