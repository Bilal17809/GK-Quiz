import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultController extends GetxController {
  final RxInt lastCorrectAnswers = 0.obs;
  final RxInt lastWrongAnswers = 0.obs;
  final RxDouble lastPercentage = 0.0.obs;

  static const String _correctAnswersKey = 'lastCorrectAnswers';
  static const String _wrongAnswersKey = 'lastWrongAnswers';
  static const String _percentageKey = 'lastPercentage';

  @override
  void onInit() {
    super.onInit();
    _loadQuizResult();
  }

  //Load the quiz result from Shared Pref
  Future<void> _loadQuizResult() async {
    final prefs = await SharedPreferences.getInstance();
    lastCorrectAnswers.value = prefs.getInt(_correctAnswersKey) ?? 0;
    lastWrongAnswers.value = prefs.getInt(_wrongAnswersKey) ?? 0;
    lastPercentage.value = prefs.getDouble(_percentageKey) ?? 0.0;
  }

  // Save the current quiz result to Shared Preferences
  Future<void> saveQuizResult({
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_correctAnswersKey, correctAnswers);
    await prefs.setInt(_wrongAnswersKey, wrongAnswers);
    await prefs.setDouble(_percentageKey, percentage);

    // Update observable values
    lastCorrectAnswers.value = correctAnswers;
    lastWrongAnswers.value = wrongAnswers;
    lastPercentage.value = percentage;
  }
}
