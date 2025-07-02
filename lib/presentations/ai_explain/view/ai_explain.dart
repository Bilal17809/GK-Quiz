import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/elongated_button.dart';
import 'package:template/presentations/ai_explain/controller/ai_explain_controller.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class AiExplain extends StatelessWidget {
  const AiExplain({super.key});

  void _copyToClipboard(String text) {
    if (text.trim().isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AiExplainController controller = Get.put(AiExplainController());

    return Scaffold(
      appBar: CustomAppBar(subtitle: 'AI Explanation'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(kBodyHp),
                  decoration: roundedSkyBlueBorderDecoration,
                  child: Row(
                    children: [
                      const Icon(Icons.topic, color: kSkyBlueColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Topic: ${controller.selectedOption.value}',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: kSkyBlueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Smart Explanation',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(kBodyHp),
                  decoration: roundedDecorationWithShadow.copyWith(
                    border: Border.all(color: greyColor.withValues(alpha: 0.3)),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kSkyBlueColor,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Generating detailed AI explanation...',
                              style: TextStyle(
                                color: greyColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.explanation.value.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/chatbot.png',
                              color: kSkyBlueColor,
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No explanation available',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: greyColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                              Text(
                                controller.isDetailedExplanation.value
                                    ? 'Detailed AI Explanation'
                                    : 'Smart AI Explanation',
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: kSkyBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.explanation.value,
                            style: context.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Retry button
                              GestureDetector(
                                onTap:
                                    () =>
                                        controller
                                            .generateDetailedExplanation(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: greenColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 16,
                                        color: greenColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Regenerate',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: greenColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Copy button
                              GestureDetector(
                                onTap:
                                    () => _copyToClipboard(
                                      controller.explanation.value,
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kSkyBlueColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.copy,
                                        size: 16,
                                        color: kSkyBlueColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Copy',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: kSkyBlueColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: kBodyHp * 2),
              // Show button only when we have basic explanation but not detailed
              Obx(
                () =>
                    controller.explanation.value.isNotEmpty &&
                            !controller.isDetailedExplanation.value
                        ? ElongatedButton(
                          onTap: () => controller.generateDetailedExplanation(),
                          height: 50,
                          width: double.infinity,
                          color: kSkyBlueColor,
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Text(
                              'Explain',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: kWhite,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
