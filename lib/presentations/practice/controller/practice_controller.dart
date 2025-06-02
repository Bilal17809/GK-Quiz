import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../quiz_levels/controller/quiz_result_controller.dart';

class PracticeController extends GetxController {
  // Observable for topic counts
  final RxMap<String, int> topicCounts = <String, int>{}.obs;
  // Initialize controllers
  final resultController = Get.put(QuizResultController());

  @override
  void onInit() {
    super.onInit();
    loadAllTopicCounts();
    loadAllQuestions();
  }

  // Add a separate method to handle async refresh
  void refreshResults() async {
    await resultController.refreshAllResults();
  }

  // Load all questions and refresh topic counts
  void loadAllQuestions() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(gridTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading questions: $e');
    }
  }

  // Load topic counts for all grid items
  void loadAllTopicCounts() {
    try {
      final quizController = Get.find<QuizController>();
      quizController.loadAllTopicCounts(gridTexts);
      topicCounts.value = Map.from(quizController.topicCounts);
    } catch (e) {
      debugPrint('Error loading topic counts: $e');
    }
  }

  /// Get grid item color for a specific index
  Color getGridItemColor(int index) {
    return gridColors[index % gridColors.length].withValues(alpha: 0.75);
  }

  /// Get grid item icon for a specific index
  String getGridItemIcon(int index) {
    return gridIcons[index % gridIcons.length];
  }

  /// Get grid item text for a specific index
  String getGridItemText(int index) {
    return gridTexts[index % gridTexts.length];
  }

  /// Get total number of grid items
  int get gridItemCount => gridIcons.length;

  /// Calculate star rating based on percentage
  List<bool> getStarRating(double percentage) {
    return List.generate(4, (starIndex) {
      double starThreshold;
      if (starIndex == 0) {
        starThreshold = 10.0;
      } else if (starIndex == 1) {
        starThreshold = 25.0;
      } else if (starIndex == 2) {
        starThreshold = 50.0;
      } else if (starIndex == 3) {
        starThreshold = 75.0;
      } else {
        starThreshold = 90.0;
      }
      return percentage >= starThreshold;
    });
  }
}
