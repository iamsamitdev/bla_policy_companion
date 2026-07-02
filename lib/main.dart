// main.dart
// import 'package:bla_policy_companion/hello_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/policy/presentation/pages/policy_list_page.dart';

void main() {
  // ครอบทั้งแอปด้วย ProviderScope — หัวใจที่เก็บ state ของทุก provider
  runApp(const ProviderScope(child: BlaApp()));
}

class BlaApp extends StatelessWidget {
  const BlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLA Policy Companion',
      theme: AppTheme.light, // ← ใช้ Design System theme
      home: const Scaffold(body: PolicyListPage()),
    );
  }
}
