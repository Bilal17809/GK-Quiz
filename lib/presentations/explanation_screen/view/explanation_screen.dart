import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/explanation_controller.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({super.key});

  void _copyToClipboard(String text) {
    if (text.trim().isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExplanationController controller = Get.put(ExplanationController());

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.topic,
                            color: kSkyBlueColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Selected Answer: ${controller.selectedOption.value}',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: kSkyBlueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.correctAnswer.value.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: greenColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Correct Answer: ${controller.correctAnswer.value}',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: greenColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'AI Explanation',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
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
                            'Generating AI explanation...',
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
                              'Smart AI Explanation',
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
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
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
