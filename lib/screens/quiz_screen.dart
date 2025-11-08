import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/utils/app_theme.dart';
import 'package:quiz_app/widgets/answer_button.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';

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

    if (provider.currentQuestionIndex >= provider.totalQuestions) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${provider.currentQuestionIndex + 1} of ${provider.totalQuestions}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
            value:
                (provider.currentQuestionIndex + 1) / provider.totalQuestions,
            backgroundColor: AppTheme.progressBackground,
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.totalQuestions,
            itemBuilder: (context, index) {
              final question = provider.questions[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        question.text,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    flex: 4,
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, optionIndex) {
                        return AnswerButton(
                          text: question.options[optionIndex],
                          onPressed: () {
                            provider.answerQuestion(optionIndex);
                            _nextQuestion(context);
                          },
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
