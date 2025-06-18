import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/ads/interstitial_ad/view/interstitial_ad.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/ai_quiz/controller/ai_quiz_controller.dart';
import '../../../core/ads/banner_ad/view/banner_ad.dart';
import '../../../core/common_widgets/common_text_field.dart';
import '../../../core/common_widgets/elongated_button.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../controller/speech_controller.dart';

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

  @override
  void initState() {
    super.initState();
    controller = Get.find<AiQuizController>();
    speechController = Get.put(SpeechController());
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
      Get.snackbar("Error", "Failed to process speech input: $e");
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
    return InterstitialAdWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(subtitle: 'AI Chat'),
        body: SafeArea(
          child: Column(
            children: [
              // Context Display Banner
              Obx(
                () => Container(
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
                ),
              ),
              // Input Container
              Container(
                margin: const EdgeInsets.all(kBodyHp),
                padding: const EdgeInsets.all(kBodyHp),
                decoration: roundedDecorationWithShadow,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Limit Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: roundedDecoration.copyWith(
                        color: greyColor.withValues(alpha: 0.05),
                        border: Border.all(
                          color: greyColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Daily Limit: 5',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: greyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Input Container
                    Container(
                      decoration: roundedDecoration.copyWith(
                        color: greyColor.withValues(alpha: 0.05),
                        border: Border.all(
                          color: greyColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Input Field
                          CommonTextField(
                            controller: inputController,
                            minLines: 3,
                            maxLines: 4,
                            hintText:
                                'Write your message here or tap the mic to speak...',
                            hintStyle: const TextStyle(
                              color: greyColor,
                              fontSize: 16,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: kBlack,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                          // Bottom Icons Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                // Speech Button
                                Obx(
                                  () => IconActionButton(
                                    onTap: _handleSpeechInput,
                                    icon: Icons.mic,
                                    color:
                                        speechController.isListening.value
                                            ? Colors.red
                                            : kSkyBlueColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconActionButton(
                                  onTap: () {
                                    inputController.clear();
                                  },
                                  icon: Icons.cancel,
                                  color: kSkyBlueColor,
                                ),
                                const SizedBox(width: 16),
                                IconActionButton(
                                  onTap: () {
                                    final text = inputController.text.trim();
                                    if (text.isNotEmpty) {
                                      _copyToClipboard(text);
                                    }
                                  },
                                  icon: Icons.copy,
                                  color: kSkyBlueColor,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Generate Button
                    Obx(
                      () => ElongatedButton(
                        height: 54,
                        width: double.infinity,
                        color:
                            controller.isLoading.value
                                ? kSkyBlueColor.withValues(alpha: 0.6)
                                : kSkyBlueColor,
                        borderRadius: BorderRadius.circular(12),
                        onTap:
                            controller.isLoading.value
                                ? null
                                : () {
                                  final text = inputController.text.trim();
                                  if (text.isNotEmpty) {
                                    controller.sendMessage(text);
                                    controller.clearChat();
                                  }
                                },
                        child:
                            controller.isLoading.value
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      kWhite,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Generate',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kWhite,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              // Chat
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(kBodyHp),
                  padding: const EdgeInsets.all(12),
                  decoration: roundedDecorationWithShadow.copyWith(
                    border: Border.all(color: greyColor.withValues(alpha: 0.3)),
                  ),
                  child: Obx(() {
                    if (controller.chatHistory.isEmpty) {
                      return Center(
                        child: Image.asset(
                          'assets/images/chatbot.png',
                          color: kSkyBlueColor,
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      );
                    }
                    scrollToBottom();
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount:
                          controller.chatHistory.length +
                          (controller.isLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.chatHistory.length &&
                            controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircularProgressIndicator(strokeWidth: 2),
                                SizedBox(width: 16),
                                Text('AI is thinking...'),
                              ],
                            ),
                          );
                        }
                        final response = controller.chatHistory[index];
                        final content = response['content']!;
                        final isUser = response['role'] == 'user';
                        // Only show AI responses, not user messages
                        if (isUser) return const SizedBox.shrink();

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: greyColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(Icons.smart_toy, size: 16),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: roundedDecoration.copyWith(
                                    color: greyColor.withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: greyColor.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content,
                                        style: context.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElongatedButton(
                                          height: 32,
                                          width: 80,
                                          onTap:
                                              () => _copyToClipboard(content),
                                          color: kSkyBlueColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: kBottomNav,
          child: BannerAdWidget(adSize: AdSize.banner),
        ),
      ),
    );
  }
}
