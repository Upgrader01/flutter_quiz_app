import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/questions.dart' as data;

class QuizProvider with ChangeNotifier {
  final List<Question> _questions = data.questions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<QuizResult> _history = [];
  List<QuizResult> get history => _history;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  int get totalQuestions => _questions.length;

  QuizProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStringList = prefs.getStringList('quiz_history') ?? [];

    _history = historyStringList
        .map((item) => QuizResult.fromJson(item))
        .toList();
    // Sorting: new ones on top
    _history.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> saveCurrentResult() async {
    final newResult = QuizResult(
      score: _score,
      totalQuestions: _questions.length,
      date: DateTime.now(),
    );
    _history.insert(0, newResult); // Add to the top of the list
    notifyListeners();

    // Save to disk
    final prefs = await SharedPreferences.getInstance();
    final historyStringList =
        _history.map((item) => item.toJson()).toList();
    await prefs.setStringList('quiz_history', historyStringList);
  }

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
