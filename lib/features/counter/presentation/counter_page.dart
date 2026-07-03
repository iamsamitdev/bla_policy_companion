import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/counter.dart';

// เปลี่ยนจาก StatelessWidget เป็น ConsumerWidget
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ใช้ ref.watch เพื่อเฝ้าดูค่า ถ้าค่าในถังเปลี่ยน หน้าจอนี้จะเปลี่ยนตามทันที
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Center(child: Text('กดไปแล้ว $count ครั้ง')),
      floatingActionButton: FloatingActionButton(
        // 2. ใช้ ref.read เมื่อต้องการสั่งงานฟังก์ชัน (ไม่ต้องการเฝ้าดูการเปลี่ยนแปลง)
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
