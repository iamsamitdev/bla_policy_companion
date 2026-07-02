import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hello_provider.g.dart'; // ⬅ ห้ามลืม! build_runner จะสร้างไฟล์นี้ให้

// provider ตัวแรกของเรา — คืนข้อความทักทาย (อ่านอย่างเดียว)
@riverpod
String hello(Ref ref) => 'สวัสดี Riverpod 👋 (BLA Policy Companion)';
