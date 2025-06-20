import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_quiz/controller/country_quiz_controller.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import 'country_quiz_page.dart';

class CountryQuizScreen extends StatefulWidget {
  const CountryQuizScreen({super.key});

  @override
  State<CountryQuizScreen> createState() => _CountryQuizScreenState();
}

class _CountryQuizScreenState extends State<CountryQuizScreen> {
  Timer? _autoProgressTimer;
  late CountryQuizController countryQuizController;
  late String topic;
  late int topicIndex;
  late int categoryIndex;
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());

  @override
  void initState() {
    interstitialAd.checkAndShowAd();
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    topic = arguments['topic'] ?? '';
    topicIndex = arguments['topicIndex'] ?? arguments['index'] ?? 1;
    categoryIndex = arguments['categoryIndex'] ?? 1;

    countryQuizController = Get.put(CountryQuizController(), permanent: false);

    countryQuizController.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });
    countryQuizController.loadQuestionsForCategory(topic, categoryIndex);
  }

  @override
  void dispose() {
    _autoProgressTimer?.cancel();
    super.dispose();
  }

  void _handleAnswerSelection(int questionIndex, String selectedOption) {
    if (countryQuizController.shouldShowAnswerResults[questionIndex] == true) {
      return;
    }

    _autoProgressTimer?.cancel();

    countryQuizController.handleAnswerSelection(questionIndex, selectedOption);

    _autoProgressTimer = Timer(Duration(seconds: 1), () {
      _moveToNextQuestion();
    });
  }

  void _moveToNextQuestion() {
    if (countryQuizController.currentQuestionIndex.value <
        countryQuizController.questionsList.length - 1) {
      countryQuizController.questionsPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    QuizSounds.playCompletionSound();
    Get.toNamed(
      RoutesName.countryResultScreen,
      arguments: {
        'topicIndex': topicIndex,
        'categoryIndex': categoryIndex,
        'topic': topic,
        'fromCustomQuiz': false,
        'selectedAnswers': countryQuizController.selectedAnswers,
        'questionsList': countryQuizController.questionsList,
      },
    );

    debugPrint('Quiz completed! Navigate to results screen.');
  }

  @override
  Widget build(BuildContext context) {
    final mobileSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        if (countryQuizController.isLoadingQuestions.value) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: countryQuizController.questionsPageController,
          physics: NeverScrollableScrollPhysics(), // Disable manual scrolling
          onPageChanged: countryQuizController.onPageChanged,
          itemCount: countryQuizController.questionsList.length,
          itemBuilder: (context, pageIndex) {
            final question = countryQuizController.questionsList[pageIndex];
            return CountryQuizPage(
              question: question,
              currentIndex: pageIndex,
              totalQuestions: countryQuizController.questionsList.length,
              controller: countryQuizController,
              mobileSize: mobileSize,
              onAnswerSelected: _handleAnswerSelection,
              topicIndex: topicIndex,
              topic: topic,
            );
          },
        );
      }),
      // bottomNavigationBar: const Padding(
      //   padding: kBottomNav,
      //   child: BannerAdWidget(),
      // ),
    );
  }
}
