import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question 1 of 5'),
      ),
      body: Center(
        child: Text('Тут будуть питання!'),
      ),
    );
  }
}