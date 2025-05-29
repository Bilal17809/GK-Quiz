import 'package:get/get.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/questions_data.dart';

class CustomizedQuizController extends GetxController {
  // Observable collections and state
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTopic = ''.obs;

  // Arguments
  String? _topic;

  // Getter for topic
  String? get topic => _topic;

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _topic = args['topic'];
      if (_topic != null) {
        currentTopic.value = _topic!;
        loadQuestionsForTopic(_topic!);
      }
    }
  }

  // Load questions for specific topic
  Future<void> loadQuestionsForTopic(String topic) async {
    isLoading.value = true;
    try {
      final questionsFromDb = await DBService.getQuestionsByTopic(topic);
      questionsList.assignAll(questionsFromDb);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load questions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get the actual option text based on the correct answer
  String getCorrectOptionText(QuestionsModel question) {
    switch (question.answer.toUpperCase()) {
      case 'A':
        return question.option1;
      case 'B':
        return question.option2;
      case 'C':
        return question.option3;
      case 'D':
        return question.option4;
      default:
        return question.answer; // fallback to answer field if it's not A,B,C,D
    }
  }
}
