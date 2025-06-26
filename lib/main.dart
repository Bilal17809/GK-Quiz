import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:template/presentations/ai_quiz/controller/ai_quiz_controller.dart';
import 'package:template/presentations/ai_quiz/controller/speech_controller.dart';
import 'package:template/presentations/country_levels/controller/country_levels_controller.dart';
import 'package:template/presentations/progress/controller/progress_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/quiz_levels/controller/quiz_result_controller.dart';
import 'package:template/presentations/splash/view/splash_screen.dart';
import 'package:toastification/toastification.dart';
import '/core/theme/app_theme.dart';
import 'ads_manager/appOpen_ads.dart';
import 'ads_manager/interstitial_ads.dart';
import 'core/local_storage/shared_preferences_storage.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Get.put(AppOpenAdController());
  Get.put(InterstitialAdController()..checkAndShowAd());
  await Get.putAsync(() => SharedPreferencesService().init());
  Get.put(QuizController());
  Get.put(QuizResultController());
  Get.put(CountryLevelsController());
  Get.put(AiQuizController());
  Get.put(SpeechController());
  Get.put(SplashController());
  Get.put<ProgressController>(ProgressController(), permanent: true);

  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("87c9689a-bb86-4612-86fd-9b104a13222d");
  OneSignal.Notifications.requestPermission(true);
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
