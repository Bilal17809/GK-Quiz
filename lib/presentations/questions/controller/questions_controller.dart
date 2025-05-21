import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/questions_data.dart';

class QuestionController {
  final DBService dbService;

  QuestionController(this.dbService);

  Future<Map<String, int>> getTopicsWithCounts() async {
    final questions = await DBService.getAllQuestions();
    final Map<String, int> topicCounts = {};

    for (var question in questions) {
      topicCounts[question.topic] = (topicCounts[question.topic] ?? 0) + 1;
    }

    return topicCounts;
  }

  Future<List<QuestionsData>> getQuestionsByTopic(String topic) {
    return DBService.getQuestionsByTopic(topic);
  }
}
