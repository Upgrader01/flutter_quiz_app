import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart'; // Створимо на наступному кроці

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextQuestion(BuildContext context) {
    final provider = context.read<QuizProvider>();

    // Якщо це було останнє питання
    if (provider.currentQuestionIndex >= provider.totalQuestions) {
      // Переходимо на екран результату
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    } else {
      // Інакше гортаємо на наступну сторінку з анімацією
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Слухаємо зміни в провайдері
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        // Показуємо прогрес у заголовку (наприклад, "Question 3 of 5")
        title: Text(
          'Question ${provider.currentQuestionIndex + 1} of ${provider.totalQuestions}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // Прибираємо кнопку "Назад", щоб користувач не міг вийти випадково
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          // Лінійний індикатор прогресу під AppBar
          child: LinearProgressIndicator(
            value: (provider.currentQuestionIndex + 1) / provider.totalQuestions,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PageView.builder(
            controller: _pageController,
            // Вимикаємо свайп пальцем, щоб не можна було пропустити питання
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.totalQuestions,
            itemBuilder: (context, index) {
              final question = provider.questions[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Текст питання
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        question.text,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Список варіантів відповідей
                  Expanded(
                    flex: 4,
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, optionIndex) {
                        return ElevatedButton(
                          onPressed: () {
                            // 1. Відповідаємо на питання в логіці
                            provider.answerQuestion(optionIndex);
                            // 2. Переходимо далі візуально
                            _nextQuestion(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surface, // Темний фон кнопки
                            foregroundColor: Colors.white, // Білий текст
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            question.options[optionIndex],
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}