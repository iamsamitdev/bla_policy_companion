// lib/features/claim/domain/claim_record.dart

/// สถานะคำขอสินไหม
enum ClaimStatus { submitted, reviewing, approved, rejected }

extension ClaimStatusLabel on ClaimStatus {
  String get label {
    switch (this) {
      case ClaimStatus.submitted:
        return 'ยื่นแล้ว';
      case ClaimStatus.reviewing:
        return 'กำลังพิจารณา';
      case ClaimStatus.approved:
        return 'อนุมัติ';
      case ClaimStatus.rejected:
        return 'ไม่อนุมัติ';
    }
  }
}

/// รายการประวัติการยื่นสินไหมหนึ่งรายการ (ชั้น Domain)
class ClaimRecord {
  final String claimRef;
  final String policyNumber;
  final double amount;
  final ClaimStatus status;
  final DateTime submittedAt;

  const ClaimRecord({
    required this.claimRef,
    required this.policyNumber,
    required this.amount,
    required this.status,
    required this.submittedAt,
  });

  /// แปลงจาก JSON ที่ได้จาก API (GET /claims)
  factory ClaimRecord.fromJson(Map<String, dynamic> json) => ClaimRecord(
    claimRef: json['claimRef'] as String,
    policyNumber: json['policyNumber'] as String,
    amount: (json['amount'] as num).toDouble(),
    status: ClaimStatus.values.byName(json['status'] as String),
    submittedAt: DateTime.parse(json['submittedAt'] as String),
  );
}
