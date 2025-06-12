import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class ProgressCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int totalValue;

  const ProgressCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: mobileWidth * 0.22,
          height: mobileWidth * 0.22,
          decoration: BoxDecoration(
            color: kTealGreen1.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kTealGreen1),
              SizedBox(height: 2),
              FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '$value/$totalValue',
                    style: Get.textTheme.titleSmall?.copyWith(color: kBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
