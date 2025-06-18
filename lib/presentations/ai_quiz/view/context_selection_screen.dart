import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/ad_controllers/interstitial_ad_controller.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/common_widgets/textform_field.dart';
import 'package:template/core/common_widgets/elongated_button.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/ai_quiz/controller/ai_quiz_controller.dart';
import 'package:toastification/toastification.dart';
import '../../../core/ad_controllers/banner_ad/view/banner_ad.dart';
import 'ai_quiz_screen.dart';

class ContextSelectionScreen extends StatefulWidget {
  const ContextSelectionScreen({super.key});

  @override
  State<ContextSelectionScreen> createState() => _ContextSelectionScreenState();
}

class _ContextSelectionScreenState extends State<ContextSelectionScreen> {
  final TextEditingController contextController = TextEditingController();
  final RxInt currentSuggestionIndex = 0.obs;
  Timer? _timer;

  final List<String> suggestedContexts = [
    "You're an AI that creates fun, educational quizzes. Keep answers short, age-friendly, and ask one question at a time without giving direct answers.",
    "Help users enhance their storytelling with feedback on plot, characters, and writing style. Be practical, supportive, and encouraging.",
    "Provide safe, personalised workouts, nutrition tips, and wellness advice. Focus on sustainable habits and motivation.",
    "Teach coding concepts clearly with examples and debugging help. Guide users step-by-step through various programming languages.",
    "Help users learn languages through conversation, grammar tips, vocabulary, and culture. Keep it fun and interactive.",
    "Support users with homework, study plans, and exam prep. Simplify tough topics and adapt to different learning styles.",
    "Offer resume help, interview practice, and career advice. Guide users toward achieving professional goals.",
    "Provide calm, supportive advice on stress, meditation, and mental wellness. Encourage positive thinking and emotional balance.",
  ];

  @override
  void initState() {
    super.initState();
    _startContextRotation();
  }

  void _startContextRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      currentSuggestionIndex.value =
          (currentSuggestionIndex.value + 1) % suggestedContexts.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    contextController.dispose();
    super.dispose();
  }

  void _startChat() {
    final context = contextController.text.trim();
    if (context.isEmpty) {
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Context Required'),
        description: Text('Please enter a context for the AI assistant'),
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 2),
        primaryColor: skyColor,
        margin: const EdgeInsets.all(8),
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
      );
      return;
    }

    final aiController = Get.put(AiQuizController());
    aiController.setContext(context);
    Get.to(() => const AiQuizScreen());
  }

  void _useSuggestedContext() {
    contextController.text = suggestedContexts[currentSuggestionIndex.value];
  }

  @override
  Widget build(BuildContext context) {
    final adManager = Get.find<InterstitialAdController>();
    adManager.maybeShowAdForScreen('ContextSelectionScreen');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(subtitle: 'Smart Quiz'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose AI Personality',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Define how the AI should behave and respond to your messages',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              // Suggested Contexts
              Container(
                padding: const EdgeInsets.all(kBodyHp),
                decoration: roundedSkyBlueBorderDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: kSkyBlueColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Suggested Context',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: kSkyBlueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        ElongatedButton(
                          height: 32,
                          width: 80,
                          color: kSkyBlueColor,
                          borderRadius: BorderRadius.circular(20),
                          onTap: _useSuggestedContext,
                          child: const Text(
                            'Use This',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        suggestedContexts[currentSuggestionIndex.value],
                        style: const TextStyle(
                          fontSize: 14,
                          color: kBlack,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Custom Context Input
              Text(
                'Or Create Your Own Context',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: greyColor.withValues(alpha: 0.3)),
                ),
                child: CustomTextFormField(
                  hintText: 'Describe how you want the AI to behave...',
                  controller: contextController,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const Spacer(),
              // Start Chat Button
              ElongatedButton(
                height: 50,
                width: double.infinity,
                color: kSkyBlueColor,
                borderRadius: BorderRadius.circular(12),
                onTap: _startChat,
                child: const Text(
                  'Start Chat',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: BannerAdWidget(adSize: AdSize.banner),
      ),
    );
  }
}
