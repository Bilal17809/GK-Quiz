import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  static SharedPreferencesService get to => Get.find();

  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
    String keyPrefix = 'result',
  }) async {
    String baseKey = '${keyPrefix}_${topicIndex}_$categoryIndex';
    await Future.wait([
      prefs.setInt('${baseKey}_correct', correctAnswers),
      prefs.setInt('${baseKey}_wrong', wrongAnswers),
      prefs.setDouble('${baseKey}_percentage', percentage),
      prefs.setString('${baseKey}_date', DateTime.now().toIso8601String()),
    ]);
  }

  Map<String, dynamic> getQuizResult(
    int topicIndex,
    int categoryIndex, {
    String keyPrefix = 'result',
  }) {
    String baseKey = '${keyPrefix}_${topicIndex}_$categoryIndex';
    return {
      'correct': prefs.getInt('${baseKey}_correct') ?? 0,
      'wrong': prefs.getInt('${baseKey}_wrong') ?? 0,
      'percentage': prefs.getDouble('${baseKey}_percentage') ?? 0.0,
      'date': prefs.getString('${baseKey}_date') ?? '',
    };
  }

  Map<String, dynamic> calculateOverallResult(
    int topicIndex,
    int totalQuestionsInTopic, {
    String keyPrefix = 'result',
    int maxCategories = 10,
  }) {
    int totalCorrect = 0, totalWrong = 0;

    for (
      int categoryIndex = 1;
      categoryIndex <= maxCategories;
      categoryIndex++
    ) {
      String baseKey = '${keyPrefix}_${topicIndex}_$categoryIndex';
      int correct = prefs.getInt('${baseKey}_correct') ?? 0;
      int wrong = prefs.getInt('${baseKey}_wrong') ?? 0;

      if (correct > 0 || wrong > 0) {
        totalCorrect += correct;
        totalWrong += wrong;
      }
    }

    double overallPercentage = 0.0;
    if (totalCorrect + totalWrong > 0 && totalQuestionsInTopic > 0) {
      overallPercentage = (totalCorrect / totalQuestionsInTopic) * 100;
    }

    return {
      'correct': totalCorrect,
      'wrong': totalWrong,
      'percentage': overallPercentage,
    };
  }

  Map<String, double> getDailyPerformance({
    List<String>? topicNames,
    Map<String, int>? topicCounts,
    String keyPrefix = 'result',
    int maxCategories = 19,
  }) {
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    Map<String, List<double>> dailyPercentages = {
      for (String day in daysOfWeek) day: [],
    };

    Set<String> allKeys = prefs.getKeys();
    for (String key in allKeys) {
      if (key.startsWith('${keyPrefix}_') && key.endsWith('_date')) {
        String dateString = prefs.getString(key) ?? '';
        if (dateString.isNotEmpty) {
          try {
            DateTime quizDate = DateTime.parse(dateString);
            String dayName = _getDayName(quizDate.weekday);
            String resultKey = key.replaceAll('_date', '_percentage');
            double percentage = prefs.getDouble(resultKey) ?? 0.0;
            if (percentage > 0) dailyPercentages[dayName]?.add(percentage);
          } catch (e) {
            debugPrint('Error parsing date: $e');
          }
        }
      }
    }

    Map<String, double> dailyAverages = {};
    for (String day in daysOfWeek) {
      List<double> percentages = dailyPercentages[day] ?? [];
      dailyAverages[day] =
          percentages.isNotEmpty
              ? percentages.reduce((a, b) => a + b) / percentages.length
              : 0.0;
    }

    return dailyAverages;
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[(weekday - 1).clamp(0, 6)];
  }

  Map<String, dynamic> getAllQuizStats(
    List<String> topicNames,
    Map<String, int> topicCounts, {
    String keyPrefix = 'result',
  }) {
    int allCorrect = 0, allWrong = 0, allAvailable = 0;
    List<double> allQuizPercentages = [];

    for (int topicIndex = 0; topicIndex < topicNames.length; topicIndex++) {
      final topicName = topicNames[topicIndex];
      allAvailable += topicCounts[topicName] ?? 0;

      for (int catIndex = 1; catIndex <= 10; catIndex++) {
        String baseKey = '${keyPrefix}_${topicIndex}_$catIndex';
        int correct = prefs.getInt('${baseKey}_correct') ?? 0;
        int wrong = prefs.getInt('${baseKey}_wrong') ?? 0;
        double percentage = prefs.getDouble('${baseKey}_percentage') ?? 0.0;

        if (correct > 0 || wrong > 0) {
          allCorrect += correct;
          allWrong += wrong;
          allQuizPercentages.add(percentage);
        }
      }
    }

    return {
      'totalCorrect': allCorrect,
      'totalWrong': allWrong,
      'totalAttempted': allCorrect + allWrong,
      'totalAvailable': allAvailable,
      'percentages': allQuizPercentages,
    };
  }

  // Learn Progress Methods
  Future<void> saveLearnProgress(String topic, int revealedCount) =>
      prefs.setInt('learn_progress_$topic', revealedCount);

  int getLearnProgress(String topic) =>
      prefs.getInt('learn_progress_$topic') ?? 0;

  Map<String, int> getAllLearnProgress(List<String> topics) => {
    for (String topic in topics) topic: getLearnProgress(topic),
  };

  int getTotalLearnProgress(List<String> topics) =>
      topics.fold(0, (total, topic) => total + getLearnProgress(topic));

  Future<void> clearLearnProgress(String topic) =>
      prefs.remove('learn_progress_$topic');

  Future<void> clearAllLearnProgress(List<String> topics) =>
      Future.wait(topics.map(clearLearnProgress));

  // Generic Methods
  Future<void> setInt(String key, int value) => prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) =>
      prefs.setDouble(key, value);
  Future<void> setString(String key, String value) =>
      prefs.setString(key, value);
  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);

  int getInt(String key, {int defaultValue = 0}) =>
      prefs.getInt(key) ?? defaultValue;
  double getDouble(String key, {double defaultValue = 0.0}) =>
      prefs.getDouble(key) ?? defaultValue;
  String getString(String key, {String defaultValue = ''}) =>
      prefs.getString(key) ?? defaultValue;
  bool getBool(String key, {bool defaultValue = false}) =>
      prefs.getBool(key) ?? defaultValue;

  Future<void> remove(String key) => prefs.remove(key);
  Future<void> clear() => prefs.clear();
  bool containsKey(String key) => prefs.containsKey(key);
}
