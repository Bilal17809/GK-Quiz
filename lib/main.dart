import 'package:template/presentations/home/view/home_screen.dart';
import '/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      // initialRoute: RoutesName.splashPage,
      // onGenerateRoute: Routes.generateRoute,
      home: HomeScreen(),
    );
  }
}
