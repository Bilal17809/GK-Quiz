import 'package:get/get.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/presentations/explanation_screen/view/explanation_screen.dart';
import '../../presentations/ai_quiz/view/ai_quiz_screen.dart';
import '../../presentations/ai_quiz/view/context_selection_screen.dart';
import '../../presentations/country/view/country_screen.dart';
import '../../presentations/country_lessons/view/country_lessons_screen.dart';
import '../../presentations/country_levels/view/country_levels_screen.dart';
import '../../presentations/country_qna/view/country_qna_screen.dart';
import '../../presentations/country_quiz/view/country_quiz_screen.dart';
import '../../presentations/country_result/view/country_result_screen.dart';
import '../../presentations/country_review/view/country_review_screen.dart';
import '../../presentations/customized_quiz/view/customized_quiz_screen.dart';
import '../../presentations/home/view/home_screen.dart';
import '../../presentations/learning_hub/view/learning_hub_screen.dart';
import '../../presentations/practice/view/practice_screen.dart';
import '../../presentations/progress/view/progress_screen.dart';
import '../../presentations/purchase/view/purchase_screen.dart';
import '../../presentations/qna/view/qna_screen.dart';
import '../../presentations/quiz/view/quiz_screen.dart';
import '../../presentations/quiz_levels/view/quiz_levels_screen.dart';
import '../../presentations/quiz_selection/view/quiz_selection_screen.dart';
import '../../presentations/result/view/result_screen.dart';
import '../../presentations/splash/view/splash_screen.dart';
import '../../presentations/terms/view/terms.dart';
import '../../presentations/terms/view/unsubscribe_info.dart';

class Routes {
  static final routes = [
    GetPage(
      name: RoutesName.homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.learningHubScreen,
      page: () => const LearningHubScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.practiceScreen,
      page: () => const PracticeScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.quizScreen,
      page: () => QuizScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),

    GetPage(
      name: RoutesName.quizLevelsScreen,
      page: () => const QuizLevelsScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.resultScreen,
      page: () => ResultScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.qnaScreen,
      page: () => QnaScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.customizedQuizScreen,
      page: () => CustomizedQuizScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.quizSelectionScreen,
      page: () => QuizSelectionScreen(),
    ),
    GetPage(
      name: RoutesName.countryScreen,
      page: () => CountryScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.countryLevelsScreen,
      page: () => CountryLevelsScreen(),
    ),
    GetPage(
      name: RoutesName.countryQuizScreen,
      page: () => CountryQuizScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.countryResultScreen,
      page: () => CountryResultScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.countryReviewScreen,
      page: () => CountryReviewScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.aiQuizScreen,
      page: () => AiQuizScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.contextSelectionScreen,
      page: () => ContextSelectionScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.countryLessonsScreen,
      page: () => CountryLessonsScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.countryQnaScreen,
      page: () => CountryQnaScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.progressScreen,
      page: () => ProgressScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.purchaseScreen,
      page: () => PurchaseScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.termsScreen,
      page: () => TermsScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.unsubscribeInfoScreen,
      page: () => UnsubscribeInfoScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.explanationScreen,
      page: () => ExplanationScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 250),
    ),
  ];
}
