import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder border;

  const CommonTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter text...',
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(16),
    this.hintStyle = const TextStyle(color: greyColor, fontSize: 16),
    this.textStyle = const TextStyle(fontSize: 16, color: kBlack),
    this.border = InputBorder.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        contentPadding: contentPadding,
      ),
      style: textStyle,
    );
  }
}
