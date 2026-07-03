// lib/features/payment/presentation/controllers/payment_history_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/payment_repository.dart';
import '../../domain/payment.dart';

part 'payment_history_controller.g.dart';

/// Controller โหลดประวัติการชำระเบี้ยแบบทีละหน้า (Lazy Loading / Pagination)
///
/// - `build()` โหลดหน้าแรก
/// - `loadMore()` โหลดหน้าถัดไปเมื่อผู้ใช้เลื่อนใกล้ท้าย list
@riverpod
class PaymentHistoryController extends _$PaymentHistoryController {
  static const int _limit = 20;

  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final List<Payment> _items = [];

  /// ยังมีหน้าถัดไปให้โหลดอีกหรือไม่ (UI ใช้ตัดสินใจแสดง spinner ท้าย list)
  bool get hasMore => _hasMore;

  @override
  Future<List<Payment>> build() async {
    return _fetchPage(reset: true);
  }

  Future<List<Payment>> _fetchPage({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _items.clear();
    }
    final repo = ref.read(paymentRepositoryProvider);
    final pageItems = await repo.fetchPayments(page: _page, limit: _limit);
    _hasMore = pageItems.length == _limit;
    _items.addAll(pageItems);
    return List.unmodifiable(_items);
  }

  /// โหลดหน้าถัดไป (เรียกตอนเลื่อนใกล้ท้าย list)
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || state.isLoading) return;
    _isLoadingMore = true;
    _page++;
    final more = await _fetchPage();
    state = AsyncValue.data(more);
    _isLoadingMore = false;
  }

  /// รีเฟรชทั้งหมด (กลับไปหน้าแรก)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(reset: true));
  }
}
