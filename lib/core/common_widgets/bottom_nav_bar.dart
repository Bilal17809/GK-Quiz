import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes_name.dart';
import '../theme/app_colors.dart'; // Adjust the path as needed

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: skyColor,
      currentIndex: currentIndex,
      selectedItemColor: kWhite,
      unselectedItemColor: kWhite.withValues(alpha: 0.5),
      onTap: (index) {
        if (index != currentIndex) {
          if (index == 0) {
            Get.toNamed(RoutesName.homeScreen);
          } else if (index == 1) {
            Get.toNamed(RoutesName.progressScreen);
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
      ],
    );
  }
}
