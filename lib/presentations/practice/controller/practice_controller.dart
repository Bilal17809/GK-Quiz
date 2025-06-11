import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/common_widgets/grid_data.dart';
import '../../quiz_levels/controller/quiz_result_controller.dart';

class PracticeController extends GetxController {
  final RxMap<String, int> topicCounts = <String, int>{}.obs;
  final resultController = Get.put(QuizResultController());

  @override
  void onInit() {
    super.onInit();
    loadAllTopicCounts();
    loadAllQuestions();
  }

  Future<void> refreshResults() async {
    await resultController.refreshAllResults();
  }

  void loadAllQuestions() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(gridTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading questions: $e');
    }
  }

  void loadAllTopicCounts() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(gridTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading topic counts: $e');
    }
  }

  Color getGridItemColor(int index) {
    return gridColors[index % gridColors.length].withValues(alpha: 0.75);
  }

  String getGridItemIcon(int index) {
    return gridIcons[index % gridIcons.length];
  }

  String getGridItemText(int index) {
    return gridTexts[index % gridTexts.length];
  }

  int get gridItemCount => gridIcons.length;

  List<bool> getStarRating(double percentage) {
    return List.generate(4, (starIndex) {
      double starThreshold;
      if (starIndex == 0) {
        starThreshold = 10.0;
      } else if (starIndex == 1) {
        starThreshold = 25.0;
      } else if (starIndex == 2) {
        starThreshold = 50.0;
      } else {
        starThreshold = 75.0;
      }
      return percentage >= starThreshold;
    });
  }
}
