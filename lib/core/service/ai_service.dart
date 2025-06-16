import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiService extends GetxController {
  final RxList<Map<String, String>> chatHistory = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentContext = ''.obs;
  final String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final String _model = 'deepseek/deepseek-r1-0528-qwen3-8b:free';
  final String _apiKey = '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';

  // final String systemContext = """
  // You are an AI assistant specialized in creating educational quizzes and learning materials.
  // Always follow these guidelines:
  // - Keep responses educational and engaging
  // - Always reply with answers that are short and concise
  // - Your tone must be so simple and friendly that a person of any age group can understand
  // - You are here only to generate quiz questions and provide information related to that
  // - Do not provide answers directly plus, ask single question at a time
  // """;

  void setContext(String context) {
    currentContext.value = context;
    clearChat();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || currentContext.value.isEmpty) return;

    chatHistory.add({
      "role": "user",
      "content": message.trim(),
    });

    isLoading.value = true;

    try {
      final List<Map<String, String>> messages = [
        {
          "role": "system",
          "content": currentContext.value,
        },
        ...chatHistory.map((msg) => {
          "role": msg["role"]!,
          "content": msg["content"]!,
        })
      ];

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": _model,
          "messages": messages,
          "max_tokens": 1000,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null) {
          final reply = data['choices'][0]['message']['content'];
          chatHistory.add({
            "role": "assistant",
            "content": reply?.toString().trim() ?? "No response received",
          });
        } else {
          chatHistory.add({
            "role": "assistant",
            "content": "Error: Invalid response format from API",
          });
        }
      } else {
        String errorMessage = "Error ${response.statusCode}: ${response.reasonPhrase}";
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage += "\nDetails: ${errorData['error']['message'] ?? errorData['error']}";
          }
        } catch (e) {
          errorMessage += "\nResponse: ${response.body}";
        }
        chatHistory.add({
          "role": "assistant",
          "content": errorMessage,
        });
      }
    } catch (e) {
      chatHistory.add({
        "role": "assistant",
        "content": "Connection error: ${e.toString()}",
      });
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    chatHistory.clear();
  }

  @override
  void onClose() {
    clearChat();
    super.onClose();
  }
}