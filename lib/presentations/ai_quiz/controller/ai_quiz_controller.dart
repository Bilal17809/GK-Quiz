import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';

import '../../../core/service/ai_service.dart';

class AiQuizController extends GetxController {
  final RxList<Map<String, String>> chatHistory = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentContext = ''.obs;

  final AiService _aiService = AiService();

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

    chatHistory.add({"role": "user", "content": message.trim()});
    isLoading.value = true;

    try {
      final List<Map<String, String>> messages = [
        {"role": "system", "content": currentContext.value},
        ...chatHistory.map(
          (msg) => {"role": msg["role"]!, "content": msg["content"]!},
        ),
      ];

      final response = await _aiService.sendMessage(messages);

      chatHistory.add({"role": "assistant", "content": response});
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    chatHistory.clear();
  }

  void copyToClipboard(String text) {
    if (text.trim().isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));
    toastification.show(
      type: ToastificationType.info,
      title: const Text('Copied'),
      description: Text('Text copied to clipboard'),
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: kSkyBlueColor,
      margin: const EdgeInsets.all(8),
      closeOnClick: true,
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void onClose() {
    clearChat();
    super.onClose();
  }
}
