// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// ช่องกรอกข้อมูลของ Design System: มี label ด้านบน + ไอคอนนำหน้า + รองรับรหัสผ่าน
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final AppIconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppType.label),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscure ? 1 : widget.maxLines,
          style: AppType.bodyStrong,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon == null
                ? null
                : HugeIcon(
                    icon: widget.icon!,
                    size: 20,
                    color: AppColors.textSubtle,
                  ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: HugeIcon(
                      icon: _hidden
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOffSlash,
                      size: 20,
                      color: AppColors.textSubtle,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
