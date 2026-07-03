// lib/features/payment/data/payment_repository.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/payment.dart';

part 'payment_repository.g.dart';

/// Repository ประวัติการชำระเบี้ย — เรียก API จริงผ่าน Dio
///
/// endpoint แบบแบ่งหน้า: GET /payments?page=&limit=
class PaymentRepository {
  final Dio _dio;
  PaymentRepository(this._dio);

  Future<List<Payment>> fetchPayments({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/payments',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data ?? <dynamic>[];
      return data
          .map((json) => Payment.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
PaymentRepository paymentRepository(Ref ref) {
  return PaymentRepository(ref.watch(dioClientProvider));
}
