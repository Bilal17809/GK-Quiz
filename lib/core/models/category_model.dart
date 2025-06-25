// Category model for organizing questions
class CategoryModel {
  final int categoryIndex;
  final String title;
  final String questionsRange;
  final int totalQuestions;
  final String topic;

  CategoryModel({
    required this.categoryIndex,
    required this.title,
    required this.questionsRange,
    required this.totalQuestions,
    required this.topic,
  });
}
