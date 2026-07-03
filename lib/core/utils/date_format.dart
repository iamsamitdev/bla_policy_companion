// lib/core/utils/date_format.dart

/// ฟอร์แมตวันที่เป็นภาษาไทยแบบย่อ (พ.ศ.) เช่น "12 มิ.ย. 2569"
/// รวมไว้ที่เดียวเพื่อใช้ซ้ำทั้งแอป (claims, payments)
String thaiDate(DateTime dt) {
  const months = [
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.',
  ];
  final local = dt.toLocal();
  return '${local.day} ${months[local.month - 1]} ${local.year + 543}';
}

/// ฟอร์แมตจำนวนเงินใส่คอมมา เช่น 12500 → "12,500"
String money(num value) {
  final s = value.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
