import '../models/question.dart';

final List<Question> questions = [
  const Question(
    text: 'Which programming language is used in Flutter?',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctAnswerIndex: 2, // Dart
  ),
  const Question(
    text: 'What is a Widget in Flutter?',
    options: ['Database', 'UI Component', 'Server request', 'Animation type'],
    correctAnswerIndex: 1, // UI Component
  ),
  const Question(
    text: 'Which widget is used to create a scrollable list?',
    options: ['Column', 'Row', 'Container', 'ListView'],
    correctAnswerIndex: 3, // ListView
  ),
  const Question(
    text: 'What is the entry point function of every Flutter app?',
    options: ['start()', 'runApp()', 'main()', 'init()'],
    correctAnswerIndex: 2, // main()
  ),
  const Question(
    text: 'Which widget arranges its children vertically?',
    options: ['Row', 'Column', 'Stack', 'ListView'],
    correctAnswerIndex: 1, // Column
  ),
];
