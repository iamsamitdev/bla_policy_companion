// lib/core/config/app_config.dart

/// ค่าตั้งของสภาพแวดล้อม (Environment Config) — Single Source of Truth
///
/// รวมค่า config ที่ขึ้นกับสภาพแวดล้อมไว้ที่เดียว แก้ที่นี่ที่เดียวเพื่อสลับ
/// dev / staging / prod หรือเปลี่ยน endpoint โดยไม่ต้องไล่แก้หลายไฟล์
abstract final class AppConfig {
  /// Base URL ของ Mock API (deploy บน Render)
  static const String apiBaseUrl = 'https://bla-mock-api.onrender.com/v1';

  /// Base URL ของรูปภาพ (เผื่อใช้ในอนาคต — ตัวอย่างการเก็บค่า config รวมที่เดียว)
  static const String imageBaseUrl = 'https://bla-mock-api.onrender.com/images';

  /// โทเคนทดสอบสำหรับวันที่ 2 (ยังไม่มีระบบ Login จริง)
  ///
  /// วันที่ 3 จะเลิกใช้ค่านี้ แล้วให้ AuthInterceptor อ่าน token จริงจาก
  /// Secure Storage หลังผู้ใช้เข้าสู่ระบบแทน
  static const String demoToken = 'mock-token-abc123';

  /// timeout การเชื่อมต่อ/รับข้อมูล (เผื่อ cold start ของ Render free tier ~30-60 วิ)
  static const Duration connectTimeout = Duration(seconds: 25);
  static const Duration receiveTimeout = Duration(seconds: 25);
}
