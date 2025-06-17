import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final SpeechToText _speech = SpeechToText();
  var isListening = false.obs;
  var isAvailable = false.obs;
  var recognizedText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }

  @override
  void onClose() {
    if (isListening.value) {
      stopListening();
    }
    super.onClose();
  }

  Future<void> initSpeech() async {
    try {
      isAvailable.value = await _speech.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          isListening.value = false;
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
      );
    } catch (e) {
      print('Failed to initialize speech recognition: $e');
      isAvailable.value = false;
    }
  }

  void startListening() {
    if (!isAvailable.value) return;

    isListening.value = true;
    recognizedText.value = '';

    _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          recognizedText.value = result.recognizedWords;
          stopListening();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      listenOptions: SpeechListenOptions(partialResults: false),
    );
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
    isListening.value = false;
  }

  void toggleListening() {
    if (isListening.value) {
      stopListening();
    } else {
      startListening();
    }
  }

  void startListeningWithDialog() {
    if (!isAvailable.value) {
      Get.snackbar("Speech Unavailable", "Speech recognition is not ready.");
      return;
    }

    isListening.value = true;
    recognizedText.value = '';

    _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          // Directly use the recognized words without translation
          recognizedText.value = result.recognizedWords;
          stopListening();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      listenOptions: SpeechListenOptions(partialResults: false),
    );
  }
}
