import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/ai_quiz/controller/ai_quiz_controller.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/common_text_field.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/routes/routes_name.dart';
import '../controller/speech_controller.dart';
import 'package:toastification/toastification.dart';

class AiQuizScreen extends StatefulWidget {
  const AiQuizScreen({super.key});

  @override
  State<AiQuizScreen> createState() => _AiQuizScreenState();
}

class _AiQuizScreenState extends State<AiQuizScreen> {
  late final AiQuizController controller;
  late final SpeechController speechController;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());


  @override
  void initState() {
    super.initState();
    controller = Get.find<AiQuizController>();
    speechController = Get.put(SpeechController());
    controller.sendInitialResponse();
    interstitialAd.checkAndShowAd();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyToClipboard(String text) {
    controller.copyToClipboard(text);
  }

  void _handleSpeechInput() async {
    try {
      await speechController.startSpeechToText();
      final recognizedText = speechController.getRecognizedText();
      if (recognizedText.isNotEmpty) {
        inputController.text = recognizedText;
      }
    } catch (e) {
      toastification.show(
        type: ToastificationType.info,
        title: const Text('Error'),
        description: Text('Failed to process speech input: $e'),
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 2),
        primaryColor: kSkyBlueColor,
        margin: const EdgeInsets.all(8),
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
      );
    }
  }

  void _sendMessage() {
    final text = inputController.text.trim();
    if (text.isNotEmpty && !controller.isLoading.value) {
      controller.sendMessage(text);
      inputController.clear();
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    Get.delete<SpeechController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Smart Chat'),
      body: SafeArea(
        child: Column(
          children: [
            // Context Header
            Obx(() {
              if (controller.currentContext.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: kSkyBlueColor.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: kSkyBlueColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: kSkyBlueColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Context: ${controller.currentContext.value.length > 100 ? '${controller.currentContext.value.substring(0, 100)}...' : controller.currentContext.value}',
                        style: const TextStyle(
                          color: kSkyBlueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Limit Banner
            Obx(
                  () => InkWell(
                onTap: () {
                  PanaraConfirmDialog.show(
                    Get.context!,
                    title: "Go Premium",
                    message:
                    "Purchase Premium to get unlimited access to Smart AI.",
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
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: kBodyHp,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                    controller.limit.value > 0
                        ? greyColor.withValues(alpha: 0.05)
                        : kRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                      controller.limit.value > 0
                          ? greyColor.withValues(alpha: 0.3)
                          : kRed.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.limit.value <= 0)
                        const Icon(Icons.warning, color: kRed, size: 16),
                      if (controller.limit.value <= 0)
                        const SizedBox(width: 4),
                      Text(
                        controller.limit.value > 0
                            ? 'Limit: ${controller.limit.value}'
                            : 'Limit Reached',
                        style: context.textTheme.bodySmall?.copyWith(
                          color:
                          controller.limit.value > 0 ? greyColor : kRed,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Chat Messages Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(kBodyHp, 0, kBodyHp, 0),
                decoration: roundedDecorationWithShadow.copyWith(
                  border: Border.all(color: greyColor.withValues(alpha: 0.3)),
                ),
                child: Obx(() {
                  if (controller.chatHistory.isEmpty &&
                      !controller.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/chatbot.png',
                            color: kSkyBlueColor,
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start a conversation!',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                    controller.chatHistory.length +
                        (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.chatHistory.length &&
                          controller.isLoading.value) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: kSkyBlueColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(
                                  Icons.smart_toy,
                                  size: 16,
                                  color: kSkyBlueColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: greyColor.withValues(alpha: 0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            kSkyBlueColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'AI is thinking...',
                                        style: TextStyle(
                                          color: greyColor,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final message = controller.chatHistory[index];
                      final content = message['content']!;
                      final isUser = message['role'] == 'user';
                      final isAssistant = message['role'] == 'assistant';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: kSkyBlueColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(
                                  Icons.smart_toy,
                                  size: 16,
                                  color: kSkyBlueColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width *
                                      0.75,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                  isUser
                                      ? kSkyBlueColor
                                      : greyColor.withValues(alpha: 0.1),
                                  borderRadius:
                                  isUser
                                      ? const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  )
                                      : const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      content,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isUser ? kWhite : kBlack,
                                        height: 1.4,
                                      ),
                                    ),
                                    if (!isUser) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap:
                                              () => _copyToClipboard(content),
                                          child: Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kSkyBlueColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.copy,
                                                  size: 14,
                                                  color: kSkyBlueColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Copy',
                                                  style: TextStyle(
                                                    color: kSkyBlueColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: kSkyBlueColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: kSkyBlueColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            // Input Area
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: roundedDecorationWithShadow.copyWith(
                border: Border.all(color: greyColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  // Input Field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 60),
                      decoration: roundedDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Speech Button
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              bottom: 4,
                            ),
                            child: Obx(
                                  () => IconActionButton(
                                onTap: _handleSpeechInput,
                                icon: Icons.mic,
                                color:
                                speechController.isListening.value
                                    ? kRed
                                    : kSkyBlueColor,
                              ),
                            ),
                          ),
                          // Text Field
                          Expanded(
                            child: CommonTextField(
                              controller: inputController,
                              minLines: 1,
                              maxLines: 4,
                              hintText: 'Type a message...',
                              hintStyle: context.textTheme.bodyMedium
                                  ?.copyWith(color: greyColor),
                              textStyle: context.textTheme.bodyMedium,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Send Button
                          Obx(
                                () => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SendButton(
                                onTap: _sendMessage,
                                isLoading: controller.isLoading.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
