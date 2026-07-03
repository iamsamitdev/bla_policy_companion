// lib/main.dart (ฉบับจริงใน branch day1)
// import 'package:bla_policy_companion/features/counter/presentation/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';

void main() {
  // ครอบแอปด้วย ProviderScope เพื่อให้ Riverpod ทำงานได้ทั้งแอป
  runApp(const ProviderScope(child: BlaApp()));
}

class BlaApp extends StatelessWidget {
  const BlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLA Policy Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashPage(),
      // home: const CounterPage(),
      // scrim ทึบคลุมพื้นที่ status bar ทุกหน้า: ป้องกันเนื้อหาที่เลื่อนขึ้น
      // ไปซ้อนกับนาฬิกา/ไอคอนระบบ และคงไอคอน status bar เป็นสีขาว
      builder: (context, child) {
        final topInset = MediaQuery.paddingOf(context).top;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Stack(
            children: [
              if (child != null) child,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topInset,
                child: const ColoredBox(color: AppColors.primaryLight),
              ),
            ],
          ),
        );
      },
    );
  }
}
