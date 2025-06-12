import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class SectionCard extends StatelessWidget {
  final AssetImage image;
  final String title;
  final Widget child;
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: roundedDecorationWithShadow.copyWith(color: kWhite),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image(image: image, width: mobileHeight * 0.045),
              SizedBox(width: 4),
              Text(title, style: Get.textTheme.titleMedium),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
