import 'package:flutter/material.dart';
import 'package:template/core/theme/app_colors.dart';

import '../../presentations/ai_quiz/controller/speech_controller.dart';

class SpeechHelper {
  static IconData getMicrophoneIcon(SpeechController controller) {
    final isListening = controller.isListening.value;
    final status = controller.speechStatus.value;
    final hasText = controller.recognizedText.value.isNotEmpty;

    if (isListening) {
      return Icons.mic;
    } else if (status == 'done' && hasText) {
      return Icons.mic;
    } else if (status == 'error') {
      return Icons.error;
    } else {
      return Icons.mic_off;
    }
  }

  static Color getMicrophoneColor(SpeechController controller) {
    final isListening = controller.isListening.value;
    final status = controller.speechStatus.value;
    final hasText = controller.recognizedText.value.isNotEmpty;

    if (isListening) {
      return kSkyBlueColor;
    } else if (status == 'done' && hasText) {
      return kSkyBlueColor;
    } else if (status == 'error') {
      return kRed;
    } else {
      return greyColor.withValues(alpha: 0.7);
    }
  }

  static String getStatusText(SpeechController controller) {
    final isListening = controller.isListening.value;
    final status = controller.speechStatus.value;
    final hasText = controller.recognizedText.value.isNotEmpty;

    if (isListening) {
      return 'Listening...';
    } else if (status == 'done' && hasText) {
      return 'Listened Successfully';
    } else if (status == 'error') {
      return 'Speech Recognition Error';
    } else {
      return 'Speech Recognition';
    }
  }

  static String getHintText(SpeechController controller) {
    final isListening = controller.isListening.value;
    final status = controller.speechStatus.value;
    final hasText = controller.recognizedText.value.isNotEmpty;

    if (isListening) {
      return 'Tap microphone to stop • Speak clearly';
    } else if (status == 'done' && hasText) {
      return 'Tap microphone to record again';
    } else if (status == 'error') {
      return 'Tap microphone to try again';
    } else {
      return 'Tap microphone to start recording';
    }
  }

  static void submitText(BuildContext context, SpeechController controller) {
    final text = controller.recognizedText.value.trim();
    if (controller.isListening.value) {
      controller.stopListening();
    }
    Navigator.of(context).pop(text);
  }
}
