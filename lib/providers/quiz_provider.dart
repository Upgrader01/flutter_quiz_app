import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import '../data/questions.dart';

class QuizProvider with ChangeNotifier {
  final List<Question> _questions = questions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<Question> get question => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  int get totalQuestions => _questions.length;

  void answerQuestion(int selectedIndex) {
    if (isQuizFinished) return;

    // Checking if the answer is correct
    final bool isCorrect =
        selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      _score++;
    }

    // Next questions
    _currentQuestionIndex++;

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }
}
