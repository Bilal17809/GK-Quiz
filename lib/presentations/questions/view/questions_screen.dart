import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/presentations/questions/widgets/question_content.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});
  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late final QuestionController _controller;
  List<QuestionsData> _questions = [];
  bool _isLoading = true;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  String get topic => Get.arguments['topic'];

  // Maps to store the state for each question
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _showAnswers = {};

  @override
  void initState() {
    super.initState();
    _controller = QuestionController(DBService());
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _controller.getQuestionsByTopic(topic);
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading questions: ${e.toString()}')),
        );
      }
    }
  }

  void _handleAnswerSelection(int questionIndex, String selectedOption) {
    setState(() {
      _selectedAnswers[questionIndex] = selectedOption;
      _showAnswers[questionIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Practice', style: context.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            height: 35,
            width: 35,
            decoration: roundedDecoration.copyWith(
              color: kOrange,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/images/notes.png', color: kWhite),
          ),
        ],
      ),
      body: QuestionsContent(
        isLoading: _isLoading,
        questions: _questions,
        pageController: _pageController,
        currentIndex: _currentIndex,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedAnswers: _selectedAnswers,
        showAnswers: _showAnswers,
        onAnswerSelected: _handleAnswerSelection,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
