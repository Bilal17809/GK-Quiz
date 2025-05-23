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

  factory QuestionsModel.fromMap(Map<String, dynamic> map) {
    return QuestionsModel(
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      answer: map['answer'],
      topicName: map['topic'],
    );
  }
}
