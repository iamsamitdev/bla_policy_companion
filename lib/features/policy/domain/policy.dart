// lib/features/policy/domain/policy.dart

// สถานะของกรมธรรม์
enum PolicyStatus { active, lapsed, pending }

class Policy {
  final String id;
  final String planName; // ชื่อแผนประกัน
  final String policyNumber; // เลขที่กรมธรรม์
  final double premium; // เบี้ยประกัน (บาท/ปี)
  final PolicyStatus status;

  const Policy({
    required this.id,
    required this.planName,
    required this.policyNumber,
    required this.premium,
    required this.status,
  });
}

// ส่วนขยายเพื่อแปลงสถานะเป็นข้อความภาษาไทย (กฎทางธุรกิจอยู่ในชั้น Domain)
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
