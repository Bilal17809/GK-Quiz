import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';
import 'package:template/presentations/questions_categories/controller/quiz_result_controller.dart';


/*
Note.................
 check your controller then compare with this,
 this is work fine just make concise and clear
*/

class ResultController extends GetxController {
  // Observable variables
  final int totalQuestions = 20;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxInt currentStep = 0.obs;


  /// Calculate results from the quiz data
  void calculateResults(int categoryIndex, int subCategoryIndex) {
    final questionsController = Get.find<QuestionsController>();
    final questions = questionsController.questions;
    final selectedAnswers = questionsController.selectedAnswers;

    int correct = 0;
    for (int i = 0; i < totalQuestions; i++) {
      if (selectedAnswers[i] != null && selectedAnswers[i] == questions[i].answer) {
        correct++;
      }
    }

    correctAnswers.value = correct;
    wrongAnswers.value = totalQuestions - correct;
    currentStep.value = totalQuestions > 0 ? ((correct * 100) ~/ totalQuestions) : 0;
    Get.put(QuizResultController1()).saveQuizResult(
      categoryIndex: categoryIndex,
      subCategoryIndex: subCategoryIndex,
      correctAnswers: correctAnswers.value,
      wrongAnswers: wrongAnswers.value,
      percentage: currentStep.value.toDouble(),
    );
  }


  /// Get percentage string
  String get resultPercentage => '${currentStep.value}%';

  void resetQuiz() {
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    currentStep.value = 0;
    final questionsController = Get.find<QuestionsController>();
    questionsController.resetQuizState();
  }
}






class QuizResultController1 extends GetxController {
  Future<void> saveQuizResult({
    required int categoryIndex,
    required int subCategoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String baseKey = 'result_${categoryIndex}_$subCategoryIndex';

    await prefs.setInt('${baseKey}_correct', correctAnswers);
    await prefs.setInt('${baseKey}_wrong', wrongAnswers);
    await prefs.setDouble('${baseKey}_percentage', percentage);
  }

  Future<Map<String, dynamic>> getQuizResult(int categoryIndex, int subCategoryIndex) async {
    final prefs = await SharedPreferences.getInstance();

    String baseKey = 'result_${categoryIndex}_$subCategoryIndex';

    return {
      'correct': prefs.getInt('${baseKey}_correct') ?? 0,
      'wrong': prefs.getInt('${baseKey}_wrong') ?? 0,
      'percentage': prefs.getDouble('${baseKey}_percentage') ?? 0.0,
    };
  }
}


