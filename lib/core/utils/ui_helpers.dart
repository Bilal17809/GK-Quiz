import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Color getOptionBackgroundColor(
  bool showAnswer,
  String correctLetter,
  String currentLetter,
  String? selectedLetter,
) {
  if (!showAnswer) return Colors.transparent;

  final isCorrect = correctLetter == currentLetter;
  final isSelected = selectedLetter == currentLetter;

  if (isCorrect) {
    return kDarkGreen1.withAlpha(64);
  } else if (isSelected) {
    return kRed.withAlpha(64);
  }
  return Colors.transparent;
}

Color getLetterContainerColor(
  bool showAnswer,
  String correctAnswer,
  String letter,
  String? selectedOption,
) {
  if (!showAnswer) return greyColor.withValues(alpha: 0.05);

  final isCorrect = correctAnswer == letter;
  final isSelected = selectedOption == letter;

  if (isCorrect) {
    return kDarkGreen1;
  } else if (isSelected) {
    return kRed;
  }
  return greyColor.withValues(alpha: 0.05);
}
