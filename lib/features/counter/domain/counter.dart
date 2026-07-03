import 'package:riverpod_annotation/riverpod_annotation.dart';

// ต้องระบุไฟล์ที่ระบบจะสร้างให้อัตโนมัติ (ชื่อเดียวกับไฟล์ปัจจุบัน .g.dart)
part 'counter.g.dart'; // ⬅ ห้ามลืม! build_runner จะสร้างไฟล์นี้ให้

@riverpod
class Counter extends _$Counter {
  // ค่าเริ่มต้นของถังข้อมูลนี้
  @override
  int build() => 0;

  // ฟังก์ชันสำหรับเปลี่ยนค่าภายในถัง
  void increment() {
    state++; // state คือค่าปัจจุบันภายในถัง ขยับเพิ่มทีละ 1
  }

  void decrement() {
    state--; // state คือค่าปัจจุบันภายในถัง ขยับลดทีละ 1
  }
}
