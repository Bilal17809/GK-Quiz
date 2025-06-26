import '../helper/html_parser.dart';

class QuestionsModel {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  final String topicName;

  QuestionsModel({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
    required this.topicName,
  });

  factory QuestionsModel.fromMap(Map<String, dynamic> map) {
    return QuestionsModel(
      question: HtmlParserHelper.toPlainText(map['question']),
      option1: HtmlParserHelper.toPlainText(map['option1']),
      option2: HtmlParserHelper.toPlainText(map['option2']),
      option3: HtmlParserHelper.toPlainText(map['option3']),
      option4: HtmlParserHelper.toPlainText(map['option4']),
      answer: HtmlParserHelper.toPlainText(map['answer']),
      topicName: HtmlParserHelper.toPlainText(map['topic']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'answer': answer,
      'topic': topicName,
    };
  }
}
