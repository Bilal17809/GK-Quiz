import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  static SharedPreferencesService get to => Get.find();
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  static const String _fontSizeLevelKey = 'font_size_level';
  static const String _fontSizeDirectionKey = 'font_size_direction';
  static const String _limitKey = 'ai_chat_limit'; // Added limit key

  Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveFontSizeLevel(int level) async {
    await setInt(_fontSizeLevelKey, level);
  }

  Future<void> saveFontSizeDirection(bool isIncreasing) async {
    await setBool(_fontSizeDirectionKey, isIncreasing);
  }

  int getFontSizeLevel() {
    return getInt(_fontSizeLevelKey);
  }

  bool getFontSizeDirection() {
    return getBool(_fontSizeDirectionKey, defaultValue: true);
  }

  Future<void> saveFontSizeSettings(int level, bool isIncreasing) async {
    await Future.wait([
      saveFontSizeLevel(level),
      saveFontSizeDirection(isIncreasing),
    ]);
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
      setInt('${baseKey}_correct', correctAnswers),
      setInt('${baseKey}_wrong', wrongAnswers),
      setDouble('${baseKey}_percentage', percentage),
      setString('${baseKey}_date', DateTime.now().toIso8601String()),
    ]);
  }

  Map<String, dynamic> getQuizResult(
    int topicIndex,
    int categoryIndex, {
    String keyPrefix = 'result',
  }) {
    String baseKey = '${keyPrefix}_${topicIndex}_$categoryIndex';
    return {
      'correct': getInt('${baseKey}_correct'),
      'wrong': getInt('${baseKey}_wrong'),
      'percentage': getDouble('${baseKey}_percentage'),
      'date': getString('${baseKey}_date'),
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
      int correct = getInt('${baseKey}_correct');
      int wrong = getInt('${baseKey}_wrong');
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
        String dateString = getString(key);
        if (dateString.isNotEmpty) {
          try {
            DateTime quizDate = DateTime.parse(dateString);
            String dayName = _getDayName(quizDate.weekday);
            String resultKey = key.replaceAll('_date', '_percentage');
            double percentage = getDouble(resultKey);
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
        int correct = getInt('${baseKey}_correct');
        int wrong = getInt('${baseKey}_wrong');
        double percentage = getDouble('${baseKey}_percentage');
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

  // Learn Progress Methods - Updated to use generic methods
  Future<void> saveLearnProgress(String topic, int revealedCount) =>
      setInt('learn_progress_$topic', revealedCount);

  int getLearnProgress(String topic) => getInt('learn_progress_$topic');

  Map<String, int> getAllLearnProgress(List<String> topics) => {
    for (String topic in topics) topic: getLearnProgress(topic),
  };

  int getTotalLearnProgress(List<String> topics) =>
      topics.fold(0, (total, topic) => total + getLearnProgress(topic));

  Future<void> clearLearnProgress(String topic) =>
      remove('learn_progress_$topic');

  Future<void> clearAllLearnProgress(List<String> topics) =>
      Future.wait(topics.map(clearLearnProgress));

  // Limit Methods
  Future<void> saveLimit(int limit) => setInt(_limitKey, limit);

  int getLimit({int defaultValue = 5}) =>
      getInt(_limitKey, defaultValue: defaultValue);

  Future<void> decrementLimit() async {
    int currentLimit = getLimit();
    if (currentLimit > 0) {
      await saveLimit(currentLimit - 1);
    }
  }

  Future<void> resetLimit({int resetValue = 5}) => saveLimit(resetValue);

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

  Future<void> clear() async {
    int currentLimit = getLimit();

    await prefs.clear();

    await saveLimit(currentLimit);
  }

  bool containsKey(String key) => prefs.containsKey(key);
}
