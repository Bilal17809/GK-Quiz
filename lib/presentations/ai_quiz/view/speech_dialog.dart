import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';
import '../../../core/common_widgets/elongated_button.dart';
import '../../../core/helper/speech_helper.dart';
import '../controller/speech_controller.dart';

class SpeechDialog extends StatelessWidget {
  const SpeechDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SpeechController>();
    final mobileWidth = MediaQuery.of(context).size.width;

    // Start listening when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startListeningWithDialog();
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && controller.isListening.value) {
          controller.stopListening();
        }
      },
      child: Dialog(
        backgroundColor: kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  SpeechHelper.getStatusText(controller),
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (controller.recognizedText.value.isNotEmpty) ...[
                  Text(
                    controller.recognizedText.value,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                ElongatedButton(
                  height: mobileWidth * 0.2,
                  width: mobileWidth * 0.2,
                  color: SpeechHelper.getMicrophoneColor(controller),
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (controller.isListening.value) {
                      controller.stopListening();
                    } else {
                      controller.startListeningWithDialog();
                    }
                  },
                  child: Icon(
                    SpeechHelper.getMicrophoneIcon(controller),
                    size: mobileWidth * 0.1,
                    color: kWhite,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  SpeechHelper.getHintText(controller),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: greyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElongatedButton(
                        height: 48,
                        color: greyColor.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (controller.isListening.value) {
                            controller.stopListening();
                          }
                          Navigator.of(context).pop();
                        },
                        width: double.infinity,
                        child: Text(
                          'Cancel',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: kWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (controller.recognizedText.value.trim().isNotEmpty)
                      Expanded(
                        child: ElongatedButton(
                          height: 48,
                          color: kSkyBlueColor,
                          borderRadius: BorderRadius.circular(12),
                          onTap:
                              () =>
                                  SpeechHelper.submitText(context, controller),
                          width: double.infinity,
                          child: Text(
                            'Use Text',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
