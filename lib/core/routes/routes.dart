// import 'package:flutter/material.dart';

// class Routes {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     // final arguments = settings.arguments;

//     switch (settings.name) {
//       // case RoutesName.splashPage:
//       //   return MaterialPageRoute(builder: (_) => const SplashPage());
//       // case RoutesName.homePage:
//       //   return MaterialPageRoute(builder: (_) => const HomePage());
//       // case RoutesName.aiDictionaryPage:
//       //   return MaterialPageRoute(builder: (_) => const AiDictionaryPage());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//               child: Text('No route defined for "${settings.name}"'),
//             ),
//           ),
//         );
//     }
//   }
// }

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/presentations/home/view/home_screen.dart';
import 'package:template/presentations/lessons/view/lessons_screen.dart';
import 'package:template/presentations/practice/view/practice_screen.dart';
import 'package:template/presentations/quiz/view/quiz_screen.dart';
import 'package:template/presentations/quiz_levels/view/quiz_levels_screen.dart';
import 'package:template/presentations/splash/view/splash_screen.dart';
import 'package:template/presentations/take_a_test_list/view/take_a_test_list.dart';
import 'package:template/presentations/take_test/view/take_test_screen.dart';
import 'package:template/presentations/result/view/result_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: RoutesName.homeScreen, page: () => const HomeScreen()),
    GetPage(name: RoutesName.splashScreen, page: () => const SplashScreen()),
    GetPage(name: RoutesName.lessonsScreen, page: () => const LessonsScreen()),
    GetPage(
      name: RoutesName.practiceScreen,
      page: () => const PracticeScreen(),
    ),
    GetPage(name: RoutesName.quizScreen, page: () => QuizScreen()),
    GetPage(name: RoutesName.testScreen, page: () => const TakeTestScreen()),
    GetPage(
      name: RoutesName.takeATestScreen,
      page: () => const TakeATestList(),
    ),
    GetPage(
      name: RoutesName.quizLevelsScreen,
      page: () => const QuizLevelsScreen(),
    ),
    GetPage(name: RoutesName.resultScreen, page: () => ResultScreen()),
  ];
}
