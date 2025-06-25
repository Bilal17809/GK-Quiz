import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/service/ai_service.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../../core/theme/app_colors.dart';

class AiQuizController extends GetxController {
  final RxList<Map<String, String>> chatHistory = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentContext = ''.obs;
  final RxInt limit = 5.obs;
  final AiService _aiService = AiService();

  void setContext(String context) {
    currentContext.value = context;
    clearChat();
  }

  void _showPremiumDialog() {
    PanaraConfirmDialog.show(
      Get.context!,
      title: "Limit Reached",
      message:
          "You have reached your limit. Purchase Premium to continue using Smart AI.",
      confirmButtonText: "Premium",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Get.back();
      },
      onTapConfirm: () {
        Get.offNamed(RoutesName.purchaseScreen);
      },
      panaraDialogType: PanaraDialogType.custom,
      color: kSkyBlueColor,
      barrierDismissible: false,
    );
  }

  String _buildSystemPrompt() {
    final context = currentContext.value;

    final expandedContext =
        context.split(' ').length <= 2
            ? "You are a helpful, friendly assistant focused on the topic of $context. You enjoy making every conversation feel like it's naturally connected to $context, no matter the subject."
            : context;

    return """$expandedContext

RULES:
- Always tie responses back to "$context" subtly and naturally.
- Even when asked factual questions, find a way to relate your answer to "$context".
- Do not apologise or say you're just an AI.
- Respond like a warm, engaging human. No technical explanations.
- Avoid stating that you've been given a context or prompt.
- If the topic drifts too far, gently bring it back to "$context" in a natural way.""";
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty ||
        currentContext.value.isEmpty ||
        limit.value <= 0) {
      if (limit.value <= 0) _showPremiumDialog();
      return;
    }

    chatHistory.add({"role": "user", "content": message.trim()});
    isLoading.value = true;

    try {
      final messages = [
        {"role": "system", "content": _buildSystemPrompt()},
        ...chatHistory,
      ];

      if (_shouldAnchorContext()) {
        messages.add({
          "role": "system",
          "content":
              "Let’s keep tying our discussion back to $currentContext. It’s an important theme.",
        });
      }

      final response = await _aiService.sendMessage(messages);
      chatHistory.add({"role": "assistant", "content": response});
      await _decrementLimit();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendInitialResponse() async {
    if (currentContext.value.isEmpty ||
        chatHistory.isNotEmpty ||
        limit.value <= 0) {
      return;
    }

    isLoading.value = true;
    try {
      final messages = [
        {"role": "system", "content": _buildSystemPrompt()},
        {
          "role": "user",
          "content":
              "Hi! Please introduce yourself in a friendly, natural way and let's start our conversation.",
        },
      ];

      final response = await _aiService.sendMessage(messages);
      chatHistory.add({"role": "assistant", "content": response});
    } finally {
      isLoading.value = false;
    }
  }

  bool _shouldAnchorContext() {
    final userMessages = chatHistory.where((e) => e['role'] == 'user').length;
    return userMessages % 3 == 0 && userMessages != 0;
  }

  Future<void> _decrementLimit() async {
    await SharedPreferencesService.to.decrementLimit();
    limit.value = SharedPreferencesService.to.getLimit();
  }

  void clearChat() {
    chatHistory.clear();
  }

  void copyToClipboard(String text) {
    if (text.trim().isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  void onInit() {
    super.onInit();
    limit.value = SharedPreferencesService.to.getLimit();
  }

  @override
  void onClose() {
    clearChat();
    super.onClose();
  }
}
