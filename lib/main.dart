import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/local_storage/shared_preferences_storage.dart';
import 'package:template/core/routes/routes.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/service/ai_service.dart';
import 'package:template/presentations/country_levels/controller/country_levels_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/quiz_levels/controller/quiz_result_controller.dart';
import 'package:toastification/toastification.dart';

import '/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferencesService().init());
  Get.put(QuizController());
  Get.put(QuizResultController());
  Get.put(CountryLevelsController());
  Get.put(AiService());

  runApp(
    DevicePreview(
      enabled: false, // Set to false before production release
      builder: (context) => const MyApp(),
    ),
  );
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

        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
