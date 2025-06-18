import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SpeechController extends GetxController {
  RxBool isListening = false.obs;
  RxString recognizedText = "".obs;

  TextEditingController controller = TextEditingController();

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  static const MethodChannel _methodChannel = MethodChannel(
    'com.teramob.gk_quiz',
  );

  Future<void> startSpeechToText({String languageISO = 'en'}) async {
    print("Starting speech recognition for language: $languageISO");
    try {
      isListening.value = true;
      final result = await _methodChannel.invokeMethod('getTextFromSpeech', {
        'languageISO': languageISO,
      });

      if (result != null && result.isNotEmpty) {
        controller.text = result;
        recognizedText.value = result;
      }
    } on PlatformException catch (e) {
      print("Error in Speech-to-Text: ${e.message}");
      recognizedText.value = "Speech recognition failed: ${e.message}";
    } finally {
      isListening.value = false;
    }
  }

  void clearData() {
    controller.clear();
    recognizedText.value = "";
  }

  String getRecognizedText() {
    return recognizedText.value;
  }
}
