// lib/features/app/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../core/icons/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../claim/presentation/pages/claims_page.dart';
import '../home/presentation/pages/home_page.dart';
import '../payment/presentation/pages/payments_page.dart';
import '../policy/presentation/pages/policy_list_page.dart';
import '../profile/presentation/pages/profile_page.dart';

/// แท็บที่เลือกอยู่ของ Bottom Navigation
///
/// Day 1: ใช้ StateProvider ง่าย ๆ เพื่อให้หน้าอื่น (เช่น ปุ่มลัดในหน้าแรก)
/// สั่งสลับแท็บได้ — Day 3 จะยกระดับเป็น GoRouter + StatefulShellRoute
final mainTabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _pages = [
    HomePage(),
    PolicyListPage(),
    ClaimsPage(),
    PaymentsPage(),
    ProfilePage(),
  ];

  static const _items = [
    (
      icon: HugeIcons.strokeRoundedHome03,
      active: HugeIcons.strokeRoundedHome03,
      label: 'หน้าแรก',
    ),
    (
      icon: HugeIcons.strokeRoundedShield01,
      active: HugeIcons.strokeRoundedShield01,
      label: 'กรมธรรม์',
    ),
    (
      icon: HugeIcons.strokeRoundedFile01,
      active: HugeIcons.strokeRoundedFile01,
      label: 'สินไหม',
    ),
    (
      icon: HugeIcons.strokeRoundedCreditCard,
      active: HugeIcons.strokeRoundedCreditCard,
      label: 'ชำระเบี้ย',
    ),
    (
      icon: HugeIcons.strokeRoundedUser,
      active: HugeIcons.strokeRoundedUser,
      label: 'โปรไฟล์',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(mainTabProvider);
    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < _items.length; i++)
                  _NavItem(
                    item: _items[i],
                    selected: i == index,
                    onTap: () => ref.read(mainTabProvider.notifier).state = i,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final ({AppIconData icon, AppIconData active, String label}) item;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSubtle;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected)
                Container(
                  width: 20,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(height: 8),
              HugeIcon(
                icon: selected ? item.active : item.icon,
                size: 24,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
