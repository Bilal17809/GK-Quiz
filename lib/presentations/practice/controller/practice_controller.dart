import 'dart:ui';

import 'package:get/get.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

class PracticeController extends GetxController {
  // Observable for topic counts
  final RxMap<String, int> topicCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllTopicCounts();
  }

  /// Load topic counts for all grid items
  void loadAllTopicCounts() {
    // Assuming you have a QuizController method or service to get topic counts
    final quizController = Get.find<QuizController>();
    quizController.loadAllTopicCounts(gridTexts);

    // Copy the topic counts to this controller
    topicCounts.value = Map.from(quizController.topicCounts);
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
      } else {
        // Other 3 stars equally divide remaining 90%
        starThreshold = 10.0 + ((starIndex) * 30.0);
      }
      return percentage >= starThreshold;
    });
  }
}
