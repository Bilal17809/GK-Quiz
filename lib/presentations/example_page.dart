import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'example.dart';
class SpeechInputScreen extends StatelessWidget {
  final TranslationController controller = Get.put(TranslationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speak & Translate')),
      body: Center(
        child: Obx(() => ElevatedButton.icon(
          onPressed: controller.isListening.value
              ? null
              : () {
            // Replace with desired language code like 'en' for English
            final languageISO = controller.languageCodes[controller.selectedLanguage1.value] ?? 'en';
            controller.startSpeechToText(languageISO);
          },
          icon: Icon(Icons.mic),
          label: Text(controller.isListening.value ? "Listening..." : "Start Speaking"),
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isListening.value ? Colors.grey : Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
        )),
      ),
    );
  }
}
