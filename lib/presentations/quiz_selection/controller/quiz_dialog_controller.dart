import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizDialogController extends GetxController {
  final selectedQuestionCount = 10.obs;
  final customController = TextEditingController();
  final hasCustomInput = false.obs;
  late final List<int> presetOptions;
  final int maxQuestions;

  QuizDialogController(this.maxQuestions);

  @override
  void onInit() {
    super.onInit();
    presetOptions = _generatePresetOptions();
    selectedQuestionCount.value = presetOptions.first;

    customController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    hasCustomInput.value = customController.text.trim().isNotEmpty;
  }

  List<int> _generatePresetOptions() {
    List<int> options = [10, 15, 20, 25];
    if (!options.contains(maxQuestions)) {
      options.add(maxQuestions);
    }
    options.sort();
    return options;
  }

  @override
  void onClose() {
    customController.removeListener(_onTextChanged);
    customController.dispose();
    super.onClose();
  }
}
