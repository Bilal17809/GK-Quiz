import 'package:get/get.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/core/models/questions_data.dart';

import '../../../core/db_service/question_db_service.dart';

class QuizSelectionController extends GetxController {
  var isLoading = true.obs;
  var topics = <String>[].obs;
  var topicQuestionCounts = <String, int>{}.obs;
  var selectedQuestionCount = 10.obs;
  var maxQuestions = 50.obs;
  var selectedTopic = ''.obs;

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

      if (topicCounts.isNotEmpty) {
        maxQuestions.value = topicCounts.values.reduce((a, b) => a > b ? a : b);
        selectedQuestionCount.value = (maxQuestions.value * 0.5).round().clamp(
          1,
          maxQuestions.value,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load topics');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTopic(String topic) {
    if (selectedTopic.value == topic) {
      selectedTopic.value = '';
      resetQuestionRange();
    } else {
      selectedTopic.value = topic;
      updateQuestionRange(topic);
    }
  }

  void updateQuestionRange(String topic) {
    int count = topicQuestionCounts[topic] ?? 0;
    if (count > 0) {
      maxQuestions.value = count;
      selectedQuestionCount.value = (count * 0.5).round().clamp(1, count);
    }
  }

  void resetQuestionRange() {
    if (topicQuestionCounts.isNotEmpty) {
      int max = topicQuestionCounts.values.reduce((a, b) => a > b ? a : b);
      maxQuestions.value = max;
      selectedQuestionCount.value = (max * 0.5).round().clamp(1, max);
    }
  }

  void updateQuestionCount(double value) =>
      selectedQuestionCount.value = value.round();

  int getQuestionCount(String topic) => topicQuestionCounts[topic] ?? 0;
  bool isSelected(String topic) => selectedTopic.value == topic;
  bool canStart() => selectedTopic.value.isNotEmpty && !isLoading.value;

  Map<String, dynamic> getQuizData() => {
    'topic': selectedTopic.value,
    'questionCount': selectedQuestionCount.value,
  };
}
