// lib/features/claim/data/claim_repository.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/claim_record.dart';

part 'claim_repository.g.dart';

/// Repository ประวัติสินไหม — เรียก API จริงผ่าน Dio
class ClaimRepository {
  final Dio _dio;
  ClaimRepository(this._dio);

  /// ดึงประวัติสินไหมทั้งหมด — GET /claims
  Future<List<ClaimRecord>> fetchClaims() async {
    try {
      final response = await _dio.get<List<dynamic>>('/claims');
      final data = response.data ?? <dynamic>[];
      return data
          .map((json) => ClaimRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
ClaimRepository claimRepository(Ref ref) =>
    ClaimRepository(ref.watch(dioClientProvider));

/// รายการสินไหม (FutureProvider) — UI watch ตัวนี้
@riverpod
Future<List<ClaimRecord>> claimList(Ref ref) async {
  return ref.watch(claimRepositoryProvider).fetchClaims();
}
