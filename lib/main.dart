import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/local_storage/shared_preferences_storage.dart';
import 'package:template/core/routes/routes.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/presentations/ai_quiz/controller/ai_quiz_controller.dart';
import 'package:template/presentations/ai_quiz/controller/speech_controller.dart';
import 'package:template/presentations/country_levels/controller/country_levels_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/quiz_levels/controller/quiz_result_controller.dart';
import 'package:template/presentations/splash/view/splash_screen.dart';
import 'package:toastification/toastification.dart';
import '/core/theme/app_theme.dart';
import 'ads_manager/appOpen_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Get.put(OpenAppAdController());
  await Get.putAsync(() => SharedPreferencesService().init());
  Get.put(QuizController());
  Get.put(QuizResultController());
  Get.put(CountryLevelsController());
  Get.put(AiQuizController());
  Get.put(SpeechController());
  Get.put(SplashController());
  // Get.put(InterstitialAdController());
  // Get.put(SplashController());

  runApp(
    DevicePreview(
      enabled: false,
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
        initialRoute: RoutesName.splashScreen,
        getPages: Routes.routes,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
