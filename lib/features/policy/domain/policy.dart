// lib/features/policy/domain/policy.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy.freezed.dart';
part 'policy.g.dart';

/// สถานะของกรมธรรม์
enum PolicyStatus { active, lapsed, pending }

/// โมเดลกรมธรรม์ (ชั้น Domain)
///
/// วันที่ 2 อัปเกรดเป็น **freezed + JSON** — immutable, copyWith, ==, hashCode
/// และ `fromJson`/`toJson` อัตโนมัติ (ลดโค้ดที่เขียนมือและ bug)
@freezed
abstract class Policy with _$Policy {
  const factory Policy({
    required String id,
    required String planName, // ชื่อแผนประกัน
    required String policyNumber, // เลขที่กรมธรรม์
    required double premium, // เบี้ยประกัน (บาท/ปี)
    required PolicyStatus status,
  }) = _Policy;

  /// แปลงจาก JSON ที่ได้จาก API (GET /policies)
  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
}

/// ส่วนขยายเพื่อแปลงสถานะเป็นข้อความภาษาไทย (กฎทางธุรกิจอยู่ในชั้น Domain)
extension PolicyStatusLabel on PolicyStatus {
  String get label {
    switch (this) {
      case PolicyStatus.active:
        return 'มีผลบังคับ';
      case PolicyStatus.lapsed:
        return 'ขาดอายุ';
      case PolicyStatus.pending:
        return 'รอดำเนินการ';
    }
  }
}

/// ข้อมูลปลอม (placeholder) สำหรับโหมด Skeleton Loading เท่านั้น
/// ใช้คู่กับ `skeletonizer` เพื่อให้มี "รูปร่าง" ข้อมูลให้ skeletonize ระหว่างโหลด
extension PolicyFake on Policy {
  static Policy fake() => const Policy(
    id: 'xxxx',
    planName: 'BLA xxxxxxxxxxxxxx',
    policyNumber: 'BLA-2569-0000',
    premium: 0,
    status: PolicyStatus.active,
  );
}
