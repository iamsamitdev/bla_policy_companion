// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

/// Provider ของ Dio client — เวอร์ชัน Day 2 (เน้น API Integration ล้วน)
///
/// ค่า config (baseUrl, token, timeout) อ่านจาก [AppConfig] ที่เดียว
/// ยังไม่เปิด SSL Pinning / Crypto Interceptor (เป็นเนื้อหา Day 3)
/// โครงสร้าง interceptor: AuthInterceptor (แนบ token + ดักจับ 401) → LogInterceptor (log)
@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // 1) แนบ Bearer token เข้าทุก request (Day 2 ใช้ demo token จาก AppConfig)
  dio.interceptors.add(AuthInterceptor(() async => AppConfig.demoToken));

  // 2) log request/response ระหว่างพัฒนา (ปิดได้เมื่อขึ้น production)
  dio.interceptors.add(LogInterceptor(responseBody: true));

  return dio;
}
