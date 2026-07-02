// lib/hello_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hello_provider.dart';

class HelloView extends ConsumerWidget {
  const HelloView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(helloProvider); // อ่านค่าจาก provider
    return Scaffold(body: Center(child: Text(text)));
  }
}

// จากนั้นใน BlaApp เปลี่ยนเป็น →  home: const HelloView(),
