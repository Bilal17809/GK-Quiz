import 'package:flutter/widgets.dart';
import 'package:template/core/theme/app_styles.dart';

class CommonRoundedElongatedButton extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final Widget child;
  final VoidCallback? onTap;

  const CommonRoundedElongatedButton({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: roundedDecoration.copyWith(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Center(child: child),
      ),
    );
  }
}
