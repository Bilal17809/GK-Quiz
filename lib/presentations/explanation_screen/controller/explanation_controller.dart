import 'package:get/get.dart';
import '../../../core/service/ai_service.dart';

class ExplanationController extends GetxController {
  final RxString explanation = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString currentTopic = ''.obs;
  final RxString correctAnswer = ''.obs;
  final RxString questionText = ''.obs;
  final RxString selectedOption = ''.obs;
  final RxInt limit = 5.obs;

  final AiService _aiService = AiService();

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
  }

  void _handleArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      currentTopic.value = args['topic'] ?? '';
      correctAnswer.value = args['correctAnswer'] ?? '';
      questionText.value = args['question'] ?? '';
      selectedOption.value = args['selectedOption'] ?? '';

      if (currentTopic.value.isNotEmpty && questionText.value.isNotEmpty) {
        generateExplanation();
      }
    }
  }

  String _buildSystemPrompt() {
    return """You are an educational AI assistant specialized in providing clear, concise explanations for quiz questions.

CONTEXT:
- Topic: ${currentTopic.value}
- Question: ${questionText.value}
- Correct Answer: ${correctAnswer.value}
- Selected Answer: ${selectedOption.value}

RULES:
- Provide a brief but comprehensive explanation of why the correct answer is right and if the selected answer is wrong then why is that
- Keep explanations educational and easy to understand
- Focus on the key concepts related to ${currentTopic.value}
- Use simple language suitable for learning
- Include relevant details only that help understand the topic better
- Maximum 1-2 sentences
- Do not use words that suggest that you have been given a context like absolutely, that's a great question etc
- Be encouraging and supportive in tone""";
  }

  Future<void> generateExplanation() async {
    if (currentTopic.value.isEmpty || questionText.value.isEmpty) {
      explanation.value =
          "Unable to generate explanation. Missing question details.";
      return;
    }

    isLoading.value = true;
    explanation.value = '';

    try {
      final messages = [
        {"role": "system", "content": _buildSystemPrompt()},
        {
          "role": "user",
          "content":
              "Please explain why '${correctAnswer.value}' is the correct answer for this ${currentTopic.value} question: '${questionText.value}'",
        },
      ];

      final response = await _aiService.sendMessage(messages);
      explanation.value = response;
    } catch (e) {
      explanation.value =
          "Sorry, we couldn't generate an explanation at this moment. Please try again later.";
    } finally {
      isLoading.value = false;
    }
  }

  void retryExplanation() {
    generateExplanation();
  }
}
