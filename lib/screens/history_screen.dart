import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<QuizProvider>().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
                'No history yet.\nPlay some quizzes!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final result = history[index];
                final percentage = (result.score / result.totalQuestions) * 100;
                Color scoreColor = percentage >= 80
                    ? AppTheme.resultExcellent
                    : (percentage >= 50
                        ? AppTheme.resultGood
                        : AppTheme.resultBad);

                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: scoreColor.withValues(alpha: 0.3)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: scoreColor.withValues(alpha: 0.1),
                      child: Text(
                        '${percentage.toInt()}%',
                        style: TextStyle(
                            color: scoreColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Score: ${result.score} / ${result.totalQuestions}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                       DateFormat('MMM d, yyyy - HH:mm').format(result.date),
                    ),
                  ),
                );
              },
            ),
    );
  }
}