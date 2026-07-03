// lib/features/claim/presentation/controllers/claim_controller.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../policy/data/policy_repository.dart';
import '../../../policy/presentation/controllers/policy_list_controller.dart';
import '../../data/claim_repository.dart';

part 'claim_controller.g.dart';

/// Controller สำหรับ "ยื่นคำขอสินไหม" (Mutation)
///
/// state เริ่มเป็น null (ยังไม่ยื่น), เป็น AsyncData(claimRef) เมื่อสำเร็จ,
/// เป็น AsyncError เมื่อพลาด — UI ใช้สถานะนี้แสดง loading/ผลลัพธ์/error
@riverpod
class ClaimController extends _$ClaimController {
  @override
  FutureOr<String?> build() => null;

  Future<void> submit({
    required String policyId,
    required double amount,
    required String reason,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() {
      return ref
          .read(policyRepositoryProvider)
          .submitClaim(policyId: policyId, amount: amount, reason: reason);
    });

    // provider นี้อาจถูก dispose ระหว่างรอ (เช่น ปิด bottom sheet ก่อนยื่นเสร็จ)
    // ต้องเช็ค ref.mounted ก่อนใช้ ref/state ต่อ ไม่งั้นจะเจอ UnmountedRefException
    if (!ref.mounted) return;

    state = result;
    if (result.hasValue) {
      // ยื่นสำเร็จ → สั่งให้รายการสินไหม + กรมธรรม์โหลดใหม่
      ref.invalidate(claimListProvider);
      ref.invalidate(policyListProvider);
    }
  }
}
