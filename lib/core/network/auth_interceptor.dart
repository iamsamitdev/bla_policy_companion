// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';

/// Interceptor ที่แนบ Bearer token เข้าทุก request และดักจับ 401
///
/// รับ [getToken] เป็นฟังก์ชันอ่าน token — Day 2 คืน demo token,
/// Day 3 จะสลับให้คืน token จาก Secure Storage โดยไม่ต้องแก้ที่อื่น
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final Future<void> Function()? onUnauthorized;

  AuthInterceptor(this.getToken, {this.onUnauthorized});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}
