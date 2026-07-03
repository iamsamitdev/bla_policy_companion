// lib/features/policy/presentation/controllers/policy_list_controller.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/policy_repository.dart';
import '../../domain/policy.dart';

part 'policy_list_controller.g.dart';

// 1) เก็บคำค้นหา (Notifier sync ง่าย ๆ)
@riverpod
class PolicySearch extends _$PolicySearch {
  @override
  String build() => '';
  void update(String keyword) => state = keyword.trim();
}

// 2) เก็บตัวกรองสถานะ (null = ทั้งหมด)
@riverpod
class PolicyStatusFilter extends _$PolicyStatusFilter {
  @override
  PolicyStatus? build() => null;
  void select(PolicyStatus? status) => state = status;
}

// 3) ดึงรายการกรมธรรม์ + Caching (keepAlive 5 นาที) + Pull-to-refresh
//    เปลี่ยนจาก FutureProvider (Day 1) เป็น AsyncNotifier เพื่อรองรับ refresh()
//    ชื่อ provider ที่ generate ยังเป็น `policyListProvider` เหมือนเดิม → UI ไม่ต้องแก้
@riverpod
class PolicyList extends _$PolicyList {
  @override
  Future<List<Policy>> build() async {
    // เก็บ cache 5 นาที ไม่ต้องโหลดซ้ำเมื่อสลับแท็บกลับมา
    final link = ref.keepAlive();
    final timer = Timer(const Duration(minutes: 5), link.close);
    ref.onDispose(timer.cancel);

    return ref.watch(policyRepositoryProvider).fetchPolicies();
  }

  /// Pull-to-refresh: บังคับดึงใหม่ทันที (กันพังด้วย AsyncValue.guard)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(policyRepositoryProvider).fetchPolicies(),
    );
  }
}

// 4) รายการที่ "ผ่านการกรองแล้ว" — รวมข้อมูล + คำค้นหา + ตัวกรองสถานะ
//    provider นี้ watch ทั้ง 3 ตัว เมื่อตัวใดเปลี่ยน UI จะอัปเดตเอง
@riverpod
List<Policy> filteredPolicyList(Ref ref) {
  final asyncPolicies = ref.watch(policyListProvider);
  final keyword = ref.watch(policySearchProvider).toLowerCase();
  final statusFilter = ref.watch(policyStatusFilterProvider);

  // ถ้าข้อมูลยังโหลดไม่เสร็จ ให้คืนลิสต์ว่างไปก่อน
  final policies = asyncPolicies.value ?? <Policy>[];

  return policies.where((policy) {
    final matchKeyword =
        keyword.isEmpty ||
        policy.planName.toLowerCase().contains(keyword) ||
        policy.policyNumber.toLowerCase().contains(keyword);
    final matchStatus = statusFilter == null || policy.status == statusFilter;
    return matchKeyword && matchStatus;
  }).toList();
}
