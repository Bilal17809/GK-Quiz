import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle? style;
  final double? width;
  final double? height;
  final Color? color;
  final Color foregroundColor;
  final BorderRadius? borderRadius;

  const SimpleTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style,
    this.width,
    this.height,
    this.color,
    required this.foregroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style:
              style?.copyWith(color: foregroundColor) ??
              TextStyle(color: foregroundColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
