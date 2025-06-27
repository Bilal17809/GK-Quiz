import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechController extends GetxController {
  RxBool isListening = false.obs;
  RxString recognizedText = "".obs;
  RxString speechStatus = "".obs;
  TextEditingController controller = TextEditingController();
  late stt.SpeechToText speech;
  bool speechEnabled = false;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  @override
  void onClose() {
    controller.dispose();
    if (isListening.value) {
      stopListening();
    }
    super.onClose();
  }

  void _initSpeech() async {
    speech = stt.SpeechToText();
    speechEnabled = await speech.initialize(
      onError: (error) {
        print('Speech recognition error: $error');
        isListening.value = false;
        speechStatus.value = "error";
      },
      onStatus: (status) {
        print('Speech recognition status: $status');
        speechStatus.value = status;
        if (status == 'done' || status == 'notListening') {
          isListening.value = false;
        }
      },
    );
  }

  void startListeningWithDialog() async {
    if (!speechEnabled) {
      print("Speech recognition not available");
      return;
    }

    if (isListening.value) {
      return;
    }

    isListening.value = true;
    recognizedText.value = "";
    speechStatus.value = "listening";

    await speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        controller.text = result.recognizedWords;

        if (result.finalResult) {
          isListening.value = false;
          speechStatus.value = "done";
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  void stopListening() async {
    if (speech.isListening) {
      await speech.stop();
    }
    isListening.value = false;
  }

  // Methods for native stt dialog
  // static const MethodChannel _methodChannel = MethodChannel(
  //   'com.ma.gkquiz.generalknowledge/MainActivity',
  // );

  // Future<void> startSpeechToText({String languageISO = 'en'}) async {
  //   print("Starting speech recognition for language: $languageISO");
  //   try {
  //     isListening.value = true;
  //     final result = await _methodChannel.invokeMethod('getTextFromSpeech', {
  //       'languageISO': languageISO,
  //     });
  //     if (result != null && result.isNotEmpty) {
  //       controller.text = result;
  //       recognizedText.value = result;
  //     }
  //   } on PlatformException catch (e) {
  //     print("Error in Speech-to-Text: ${e.message}");
  //     recognizedText.value = "Speech recognition failed: ${e.message}";
  //   } finally {
  //     isListening.value = false;
  //   }
  // }

  void clearData() {
    controller.clear();
    recognizedText.value = "";
    speechStatus.value = "";
  }

  String getRecognizedText() {
    return recognizedText.value;
  }

  bool get isProcessing =>
      speechStatus.value == 'done' &&
      isListening.value == false &&
      recognizedText.value.isNotEmpty;
}
