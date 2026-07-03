// lib/features/policy/data/policy_repository.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/policy.dart';

part 'policy_repository.g.dart';

/// Repository ของกรมธรรม์ — เวอร์ชันเรียก API จริงผ่าน Dio
///
/// วันที่ 1 เป็น mock ในเครื่อง วันนี้ "ถอด mock ออก เสียบ Dio เข้าไปแทน"
/// โดย signature เหมือนเดิม → Controller/UI ไม่ต้องแก้ (พลังของการแยกชั้น + DI)
class PolicyRepository {
  final Dio _dio;
  PolicyRepository(this._dio);

  /// ดึงรายการกรมธรรม์ — GET /policies
  Future<List<Policy>> fetchPolicies() async {
    try {
      final response = await _dio.get<List<dynamic>>('/policies');
      final data = response.data ?? <dynamic>[];
      return data
          .map((json) => Policy.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e); // แปลง error ให้เป็นมิตรกับผู้ใช้
    }
  }

  /// ยื่นคำขอสินไหม (Mutation) — POST /policies/:id/claims → คืนเลขอ้างอิง
  Future<String> submitClaim({
    required String policyId,
    required double amount,
    required String reason,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/policies/$policyId/claims',
        data: {'amount': amount, 'reason': reason},
      );
      return response.data?['claimRef'] as String? ?? '-';
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

/// ฉีด Dio เข้า Repository ผ่าน Provider
@riverpod
PolicyRepository policyRepository(Ref ref) {
  return PolicyRepository(ref.watch(dioClientProvider));
}
