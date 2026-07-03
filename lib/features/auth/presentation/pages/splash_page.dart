// lib/features/auth/presentation/pages/splash_page.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_logo.dart';
import 'login_page.dart';

/// หน้า Splash — โลโก้กลางจอบนพื้น gradient + แถบโหลด
/// Day 1: หน่วงเวลาแล้วไปหน้า Login (ยังไม่เช็ค session จริง — เป็นเนื้อหา Day 3)
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1800), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const AppLogo(full: true, size: 240, radius: 40),
              const SizedBox(height: 22),
              Text(
                'POLICY COMPANION',
                style: AppType.label.copyWith(
                  color: Colors.white70,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation(AppColors.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'v1.0.0',
                style: AppType.caption.copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
