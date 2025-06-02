import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/core/models/country_grid.dart';

import '../../quiz/controller/quiz_controller.dart';

class CountryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  // Observable for topic counts
  final RxMap<String, int> topicCounts = <String, int>{}.obs;

  final double imageWidth = 1000;
  final RxDouble shift = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        shift.value = (animation.value * imageWidth) % imageWidth;
      });
    loadAllTopicCounts();
    loadAllQuestions();
  }

  // Load all questions and refresh topic counts
  void loadAllQuestions() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(countryTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading questions: $e');
    }
  }

  // Load topic counts for all grid items
  void loadAllTopicCounts() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(countryTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading topic counts: $e');
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
