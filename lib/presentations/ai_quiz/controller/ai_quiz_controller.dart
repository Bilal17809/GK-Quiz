import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/service/ai_service.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';

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

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || currentContext.value.isEmpty) return;

    if (limit.value <= 0) {
      _showPremiumDialog();
      return;
    }

    chatHistory.add({"role": "user", "content": message.trim()});
    isLoading.value = true;

    try {
      final List<Map<String, String>> messages = [
        {"role": "system", "content": currentContext.value},
        ...chatHistory.map((msg) {
          String role = msg["role"]!;
          if (role == "system" && msg != chatHistory.first) {
            role = "assistant";
          }
          return {"role": role, "content": msg["content"]!};
        }),
      ];

      final response = await _aiService.sendMessage(messages);

      chatHistory.add({"role": "assistant", "content": response});

      await _decrementLimit();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendInitialResponse() async {
    if (currentContext.value.isEmpty) return;
    if (chatHistory.isNotEmpty) return;

    if (limit.value <= 0) {
      return;
    }

    isLoading.value = true;

    try {
      final List<Map<String, String>> messages = [
        {"role": "system", "content": currentContext.value},
        {
          "role": "user",
          "content":
              "Hi! I'd like to start. Please introduce yourself based on the context provided and let's begin.",
        },
      ];

      final response = await _aiService.sendMessage(messages);

      chatHistory.add({"role": "assistant", "content": response});
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _decrementLimit() async {
    await SharedPreferencesService.to.decrementLimit();
    limit.value = SharedPreferencesService.to.getLimit();
  }

  void _loadLimit() {
    limit.value = SharedPreferencesService.to.getLimit();
  }

  void clearChat() {
    chatHistory.clear();
  }

  void copyToClipboard(String text) {
    if (text.trim().isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void onInit() {
    super.onInit();
    _loadLimit();
  }

  @override
  void onClose() {
    clearChat();
    super.onClose();
  }
}
