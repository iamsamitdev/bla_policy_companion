// lib/core/network/api_exception.dart
import 'package:dio/dio.dart';

/// Exception ของแอปที่สื่อความหมายกับผู้ใช้ (แปลงมาจาก DioException)
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// แปลง DioException ดิบ → ApiException ที่เป็นมิตรกับผู้ใช้
///
/// รวม logic การแปล error ไว้ที่เดียว เรียกใช้จากทุก repository
ApiException mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiException('การเชื่อมต่อใช้เวลานานเกินไป กรุณาลองใหม่');
    case DioExceptionType.badResponse:
      final code = error.response?.statusCode;
      if (code == 401) {
        return const ApiException(
          'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่',
          statusCode: 401,
        );
      }
      if (code == 404) {
        return const ApiException('ไม่พบข้อมูลที่ต้องการ', statusCode: 404);
      }
      return ApiException(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด ($code)',
        statusCode: code,
      );
    case DioExceptionType.connectionError:
      return const ApiException('ไม่สามารถเชื่อมต่อเครือข่ายได้');
    default:
      return const ApiException('เกิดข้อผิดพลาดที่ไม่คาดคิด');
  }
}
