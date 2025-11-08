import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:quiz_app/utils/app_theme.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';
import '../models/result_data.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  ResultData _calculateResult(double percentage) {
    if (percentage >= 80) {
      return ResultData(
        text: 'Excellent work!',
        color: AppTheme.resultExcellent,
        icon: Icons.emoji_events_rounded,
        confettiEmission: 0.07,
        confettiParticles: 25,
        shouldPlayConfetti: true,
      );
    } else if (percentage >= 50) {
      return ResultData(
        text: 'Not bad!',
        color: AppTheme.resultGood,
        icon: Icons.emoji_events_rounded,
        confettiEmission: 0.02,
        confettiParticles: 15,
        shouldPlayConfetti: true,
      );
    } else {
      return ResultData(
        text: 'Try again!',
        color: AppTheme.resultBad,
        icon: Icons.sentiment_dissatisfied_rounded,
        confettiEmission: 0.01,
        confettiParticles: 1,
        shouldPlayConfetti: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final score = provider.score;
    final totalQuestions = provider.totalQuestions;
    final percentage = (totalQuestions > 0)
        ? (score / totalQuestions) * 100
        : 0.0;

    final resultData = _calculateResult(percentage);

    if (resultData.shouldPlayConfetti) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Icon(resultData.icon, size: 120, color: resultData.color),
                  const SizedBox(height: 24),
                  Text(
                    resultData.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: resultData.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your result:',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppTheme.textGrey,),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score / $totalQuestions',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<QuizProvider>().resetQuiz();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      context.read<QuizProvider>().resetQuiz();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Back to Home'),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: resultData.confettiEmission,
            numberOfParticles: resultData.confettiParticles,
            gravity: 0.2,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }
}
