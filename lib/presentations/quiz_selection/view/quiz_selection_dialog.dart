import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../core/common_widgets/common_drop_down.dart';
import '../../../core/common_widgets/elongated_button.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/quiz_dialog_controller.dart';

class QuizSelectionDialog extends StatelessWidget {
  final String topic;
  final int maxQuestions;
  final Function(int) onStartQuiz;

  const QuizSelectionDialog({
    super.key,
    required this.topic,
    required this.maxQuestions,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizDialogController(maxQuestions));

    return AlertDialog(
      backgroundColor: kWhite,
      title: Center(
        child: Text('$topic Quiz', style: context.textTheme.titleMedium),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select number of questions (Max: $maxQuestions)',
              style: context.textTheme.bodyMedium?.copyWith(
                color: textGreyColor,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonDropDown<int>(
                    value: controller.selectedQuestionCount.value,
                    items: controller.presetOptions,
                    onChanged: (value) {
                      controller.selectedQuestionCount.value = value!;
                      // Clear text field when dropdown is used
                      controller.customController.clear();
                    },
                    itemBuilder: (value) => '$value Questions',
                    maxHeight: 200.0,
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            CustomTextFormField(
              style: context.textTheme.bodyMedium,
              controller: controller.customController,
              hintText: 'Enter number (1-$maxQuestions)',
              keyboardType: TextInputType.number,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElongatedButton(
                onTap: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.delete<QuizDialogController>();
                  });
                },
                height: 50,
                width: double.infinity,
                color: skyColor,
                borderRadius: BorderRadius.circular(12),
                child: Text(
                  'Cancel',
                  style: context.textTheme.titleSmall?.copyWith(color: kWhite),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElongatedButton(
                onTap: () {
                  int? finalCount;
                  String? errorMessage;

                  if (controller.customController.text.trim().isNotEmpty) {
                    final customValue = int.tryParse(
                      controller.customController.text.trim(),
                    );
                    if (customValue == null ||
                        customValue < 1 ||
                        customValue > maxQuestions) {
                      errorMessage =
                          'Please enter a valid number between 1 and $maxQuestions';
                    } else {
                      finalCount = customValue;
                    }
                  } else {
                    finalCount = controller.selectedQuestionCount.value;
                  }

                  if (errorMessage != null) {
                    toastification.show(
                      type: ToastificationType.warning,
                      title: const Text('Invalid Number'),
                      description: Text(errorMessage),
                      style: ToastificationStyle.flatColored,
                      autoCloseDuration: const Duration(seconds: 2),
                      primaryColor: kCoral,
                      margin: const EdgeInsets.all(8),
                      closeOnClick: true,
                      alignment: Alignment.bottomCenter,
                    );
                  } else if (finalCount != null) {
                    Get.back();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Get.delete<QuizDialogController>();
                      onStartQuiz(finalCount!);
                    });
                  }
                },
                height: 50,
                width: double.infinity,
                color: skyColor,
                borderRadius: BorderRadius.circular(12),
                child: Text(
                  'Start Quiz',
                  style: context.textTheme.titleSmall?.copyWith(color: kWhite),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
