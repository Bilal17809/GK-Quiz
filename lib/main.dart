import 'package:get/route_manager.dart';
import 'package:template/core/routes/routes.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:toastification/toastification.dart';
import '/core/theme/app_theme.dart';
import 'package:flutter/material.dart';



/*
Revise all Files and their names,
secondly "Navigate" the screen must from Ui Page,
usually route use in UI where User interact, not in contrl,
see all file and review
*/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        initialRoute: RoutesName.homeScreen,
        getPages: Routes.routes,
      ),
    );
  }
}