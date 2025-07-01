import 'package:get/get.dart';
import '../../../core/service/ai_service.dart';

class AiExplainController extends GetxController {
  final RxString explanation = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedOption = ''.obs;
  final RxBool isDetailedExplanation = false.obs;
  final RxInt limit = 5.obs;
  final AiService _aiService = AiService();

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
  }

  void _handleArguments() {
    final args = Get.arguments;
    if (args != null && args is String) {
      selectedOption.value = args;
      if (selectedOption.value.isNotEmpty) {
        generateExplanation();
      }
    }
  }

  String _buildBasicSystemPrompt() {
    return """You are an educational AI assistant specialized in providing clear, concise explanations for various topics and concepts.

CONTEXT:
- Selected Topic/Answer: ${selectedOption.value}

RULES:
- Provide a brief but comprehensive explanation of the given topic or concept
- Keep explanations educational and easy to understand
- Use simple language suitable for learning
- Include relevant details that help understand the topic better
- Maximum 1-2 sentences for concise explanation
- Do not use words that suggest that you have been given a context like absolutely, that's a great question etc
- Be encouraging and supportive in tone
- Focus on providing clear definition and key points""";
  }

  String _buildDetailedSystemPrompt() {
    return """You are an expert educational AI assistant specialized in providing comprehensive, detailed explanations for various topics and concepts.

CONTEXT:
- Selected Topic/Answer: ${selectedOption.value}

RULES:
- Provide a thorough, detailed explanation of the given topic or concept
- Break down complex ideas into understandable parts
- Include examples, analogies, or real-world applications where relevant
- Explain the significance and context of the topic
- Cover multiple aspects: definition, importance, applications, examples
- Use clear, educational language but be comprehensive
- Structure the explanation logically with good flow
- Aim for 3-5 paragraphs for detailed coverage
- Include practical implications or relevance
- Be encouraging and supportive in tone
- Do not use words that suggest that you have been given a context like absolutely, that's a great question etc
- Focus on providing educational value and deep understanding""";
  }

  Future<void> generateExplanation() async {
    if (selectedOption.value.isEmpty) {
      explanation.value = "Unable to generate explanation. No topic provided.";
      return;
    }

    isLoading.value = true;
    explanation.value = '';
    isDetailedExplanation.value = false;

    try {
      final messages = [
        {"role": "system", "content": _buildBasicSystemPrompt()},
        {
          "role": "user",
          "content": "Please explain: '${selectedOption.value}'",
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

  Future<void> generateDetailedExplanation() async {
    if (selectedOption.value.isEmpty) {
      explanation.value = "Unable to generate explanation. No topic provided.";
      return;
    }

    isLoading.value = true;
    isDetailedExplanation.value = true;

    try {
      final messages = [
        {"role": "system", "content": _buildDetailedSystemPrompt()},
        {
          "role": "user",
          "content":
              "Please provide a detailed explanation of: '${selectedOption.value}'",
        },
      ];

      final response = await _aiService.sendMessage(messages);
      explanation.value = response;
    } catch (e) {
      explanation.value =
          "Sorry, we couldn't generate a detailed explanation at this moment. Please try again later.";
    } finally {
      isLoading.value = false;
    }
  }

  void retryExplanation() {
    generateDetailedExplanation();
  }
}
