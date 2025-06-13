import 'package:get/get.dart';
import 'package:template/core/models/questions_data.dart';

import '../../../core/common_widgets/grid_data.dart';
import '../../../core/db_service/question_db_service.dart';

class QuizSelectionController extends GetxController {
  var isLoading = true.obs;
  var topics = <String>[].obs;
  var topicQuestionCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTopics();
  }

  Future<void> loadTopics() async {
    try {
      isLoading.value = true;
      List<QuestionsModel> questionsList = await DBService.getAllQuestions();
      Map<String, int> topicCounts = {};

      for (var question in questionsList) {
        if (gridTexts.contains(question.topicName)) {
          topicCounts[question.topicName] =
              (topicCounts[question.topicName] ?? 0) + 1;
        }
      }

      topics.value =
          gridTexts
              .where(
                (topic) =>
                    topicCounts[topic] != null && topicCounts[topic]! > 0,
              )
              .toList();
      topicQuestionCounts.value = topicCounts;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load topics');
    } finally {
      isLoading.value = false;
    }
  }

  int getQuestionCount(String topic) => topicQuestionCounts[topic] ?? 0;
}
