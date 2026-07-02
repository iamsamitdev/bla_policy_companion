// lib/features/policy/data/policy_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/policy.dart';

part 'policy_repository.g.dart';

class PolicyRepository {
  // ดึงรายการกรมธรรม์ (จำลอง delay เหมือนเรียก API จริง)
  Future<List<Policy>> fetchPolicies() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const [
      Policy(
        id: 'P001',
        planName: 'BLA ตลอดชีพ มั่นคง 99',
        policyNumber: 'BLA-2569-0001',
        premium: 24000,
        status: PolicyStatus.active,
      ),
      Policy(
        id: 'P002',
        planName: 'BLA สะสมทรัพย์ 10/5',
        policyNumber: 'BLA-2569-0002',
        premium: 50000,
        status: PolicyStatus.pending,
      ),
      Policy(
        id: 'P003',
        planName: 'BLA คุ้มครองสุขภาพ พลัส',
        policyNumber: 'BLA-2569-0003',
        premium: 18500,
        status: PolicyStatus.lapsed,
      ),
      Policy(
        id: 'P004',
        planName: 'BLA บำนาญมั่นคง 60',
        policyNumber: 'BLA-2569-0004',
        premium: 36000,
        status: PolicyStatus.active,
      ),
    ];
  }
}

// ฉีด Repository ผ่าน Provider — ชั้นบนเรียกใช้ผ่าน ref โดยไม่ต้องสร้างเอง
@riverpod
PolicyRepository policyRepository(Ref ref) {
  return PolicyRepository();
}
