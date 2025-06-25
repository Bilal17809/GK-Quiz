import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../routes/routes_name.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await PanaraConfirmDialog.show(
          context,
          title: "Exit App?",
          message: "Do you really want to exit the app?",
          confirmButtonText: "Exit",
          cancelButtonText: "Cancel",
          onTapCancel: () => Navigator.pop(context, false),
          onTapConfirm: () => Navigator.pop(context, true),
          panaraDialogType: PanaraDialogType.normal,
          barrierDismissible: false,
        );
        return exit ?? false;
      },
      child: BottomNavigationBar(
        backgroundColor: kSkyBlueColor,
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
      ),
    );
  }
}
