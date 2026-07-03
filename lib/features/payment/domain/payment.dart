// lib/features/payment/domain/payment.dart

/// รายการประวัติการชำระเบี้ยหนึ่งรายการ (ใช้สาธิต Lazy Loading / Pagination)
class Payment {
  final String id;
  final String title;
  final double amount;
  final DateTime paidAt;

  const Payment({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidAt,
  });

  /// แปลงจาก JSON ที่ได้จาก API (GET /payments)
  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    paidAt: DateTime.parse(json['paidAt'] as String),
  );
}
