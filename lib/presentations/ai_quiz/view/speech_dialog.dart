import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';
import '../../../core/common_widgets/elongated_button.dart';
import '../controller/speech_controller.dart';

class SpeechDialog extends StatefulWidget {
  const SpeechDialog({super.key});

  @override
  State<SpeechDialog> createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog> {
  late final SpeechController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SpeechController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startListeningWithDialog();
    });

    ever(controller.recognizedText, (String text) {
      if (text.isNotEmpty && mounted) {
        Navigator.of(context).pop(text);
      }
    });
  }

  @override
  void dispose() {
    if (controller.isListening.value) {
      controller.stopListening();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
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
                  controller.isListening.value ? 'Listening...' : 'Speak now',
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                ElongatedButton(
                  height: mobileWidth * 0.2,
                  width: mobileWidth * 0.2,
                  color:
                      controller.isListening.value
                          ? kSkyBlueColor
                          : greyColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (controller.isListening.value) {
                      controller.stopListening();
                    } else {
                      controller.startListeningWithDialog();
                    }
                  },
                  child: Icon(
                    controller.isListening.value ? Icons.mic : Icons.mic_off,
                    size: mobileWidth * 0.1,
                    color: kWhite,
                  ),
                ),
                const SizedBox(height: 16),
                if (controller.isListening.value)
                  Text(
                    'Tap microphone to stop',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: greyColor,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Powered by Google',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: greyColor,
                  ),
                ),
                const SizedBox(height: 24),
                ElongatedButton(
                  height: 48,
                  width: double.infinity,
                  color: kSkyBlueColor,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (controller.isListening.value) {
                      controller.stopListening();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: kWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
