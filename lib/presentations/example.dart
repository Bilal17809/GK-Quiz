import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:translator/translator.dart';

class TranslationController extends GetxController {
  RxString selectedLanguage1 = "English".obs;
  RxString selectedLanguage2 = "Spanish".obs;
  RxString translatedText = "".obs;
  RxBool isListening = false.obs;
  RxBool isLoading = false.obs;
  final pitch = 0.5.obs;
  final speed = 0.5.obs;
  final isSpeechPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose() {

    super.onClose();
  }
  TextEditingController controller = TextEditingController();
  final translator = GoogleTranslator();

  final Map<String, String> languageCodes = {
    'English': 'en',
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Dutch': 'nl',
    'Russian': 'ru',
    'Chinese (Simplified)': 'zh-cn',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Arabic': 'ar',
    'Hindi': 'hi',
    'Urdu': 'ur',
    'Bengali': 'bn',
    'Punjabi': 'pa',
    'Turkish': 'tr',
    'Vietnamese': 'vi',
    'Thai': 'th',
    'Indonesian': 'id',
    'Tagalog': 'tl',
    'Hebrew': 'he',
    'Swedish': 'sv',
    'Norwegian': 'no',
    'Danish': 'da',
    'Finnish': 'fi',
    'Polish': 'pl',
    'Greek': 'el',
    'Czech': 'cs',
    'Hungarian': 'hu',
    'Romanian': 'ro',
    'Ukrainian': 'uk',
    'Malay': 'ms',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Kannada': 'kn',
    'Marathi': 'mr',
    'Gujarati': 'gu',
    'Swahili': 'sw',
    'Zulu': 'zu',
  };
  final languageFlags = {
    'Afrikaans': 'ZA',
    'Albanian': 'AL',
    'Amharic': 'ET',
    'Arabic': 'AE',
    'Armenian': 'AM',
    'Azerbaijani': 'AZ',
    'Basque': 'ES',
    'Belarusian': 'BY',
    'Bengali': 'BD',
    'Bosnian': 'BA',
    'Bulgarian': 'BG',
    'Catalan': 'ES',
    'Chinese (Simplified)': 'CN',
    'Chinese (Traditional)': 'TW',
    'Croatian': 'HR',
    'Czech': 'CZ',
    'Danish': 'DK',
    'Dutch': 'NL',
    'English': 'US',
    'Estonian': 'EE',
    'Filipino': 'PH',
    'Finnish': 'FI',
    'French': 'FR',
    'Georgian': 'GE',
    'German': 'DE',
    'Greek': 'GR',
    'Gujarati': 'IN',
    'Haitian Creole': 'HT',
    'Hebrew': 'IL',
    'Hindi': 'IN',
    'Hungarian': 'HU',
    'Icelandic': 'IS',
    'Indonesian': 'ID',
    'Irish': 'IE',
    'Italian': 'IT',
    'Japanese': 'JP',
    'Kannada': 'IN',
    'Kazakh': 'KZ',
    'Khmer': 'KH',
    'Korean': 'KR',
    'Kurdish': 'IQ',
    'Latvian': 'LV',
    'Lithuanian': 'LT',
    'Macedonian': 'MK',
    'Malay': 'MY',
    'Maltese': 'MT',
    'Marathi': 'IN',
    'Mongolian': 'MN',
    'Nepali': 'NP',
    'Norwegian': 'NO',
    'Persian': 'IR',
    'Polish': 'PL',
    'Portuguese (Brazil)': 'BR',
    'Portuguese (Portugal)': 'PT',
    'Punjabi': 'PK',
    'Romanian': 'RO',
    'Russian': 'RU',
    'Serbian': 'RS',
    'Slovak': 'SK',
    'Slovenian': 'SI',
    'Spanish': 'ES',
    'Swahili': 'KE',
    'Swedish': 'SE',
    'Tamil': 'LK',
    'Telugu': 'IN',
    'Thai': 'TH',
    'Turkish': 'TR',
    'Ukrainian': 'UA',
    'Urdu': 'PK',
    'Vietnamese': 'VN',
    'Welsh': 'GB',
    'Yiddish': 'IL',
  };

  final List<String> _rtlLanguages = ['ar', 'he', 'ur', 'fa'];
  bool isRTLLanguage(String language) {
    final languageCode = languageCodes[language] ?? 'en';
    return _rtlLanguages.contains(languageCode);
  }

  static const MethodChannel _methodChannel =
  MethodChannel('com.example.getx_tut/speech_Text');

  Future<void> startSpeechToText(String languageISO) async {
    print("Translation Screen selected language Code ------------${languageISO} ----------");
    try {
      isListening.value = true;
      print("Starting speech recognition for language: $languageISO");
      final result = await _methodChannel.invokeMethod('getTextFromSpeech', {'languageISO': languageISO});

      if (result != null && result.isNotEmpty) {
        controller.text = result;
        await handleUserActionTranslate(result);
      }
    } on PlatformException catch (e) {
      print("####################### Error in Speech-to-Text: ${e.message}");
    } finally {
      isListening.value = false;
    }
  }

  static const MethodChannel _channel = MethodChannel('com.example.getx_tut/tts');

  Future<void> speakUsingNative(String text, String languageCode) async {
    try {
      await _channel.invokeMethod('speakText', {'text': text, 'language': languageCode});
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  Future<void> handleUserActionTranslate(String text) async {
    await translate(text);
  }

  Future<void> translate(String text) async {
    if (text.isEmpty) {
      translatedText.value = "Please enter text to translate.";
      return;
    }

    isLoading.value = true; // Show loading indicator
    try {
      final sourceLang = languageCodes[selectedLanguage1.value] ?? 'en';
      final targetLang = languageCodes[selectedLanguage2.value] ?? 'es';

      final result = await translator.translate(text, from: sourceLang, to: targetLang);

      translatedText.value = result.text;
      // await speakText();

    } catch (e) {
      translatedText.value = "Translation failed: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Method to clear the input and output text
  void clearData() {
    controller.clear();
    translatedText.value = "";
  }
}
