import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final score = provider.score;
    final totalQuestions = provider.totalQuestions;
    final percentage = (score / totalQuestions) * 100;

    // Налаштування конфеті
    double confettiEmissionFrequency = 0.0; // За замовчуванням вимкнено
    int confettiNumberOfParticles = 0;

    String resultText;
    Color resultColor;

    if (percentage >= 80) {
      resultText = 'Excellent work!';
      resultColor = Colors.greenAccent;
      // Максимальне свято!
      confettiEmissionFrequency = 0.05;
      confettiNumberOfParticles = 20;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    } else if (percentage >= 50) {
      resultText = 'Not bad!';
      resultColor = Colors.orangeAccent;
      // Половина свята
      confettiEmissionFrequency = 0.02; // Рідше
      confettiNumberOfParticles = 10; // Менше
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    } else {
      resultText = 'Try again!';
      resultColor = Colors.redAccent;
      // Ніякого свята :(
    }

    return Scaffold(
      // Stack потрібен, щоб конфеті малювалися поверх усього
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
                  Icon(
                    percentage >= 50
                        ? Icons.emoji_events_rounded
                        : Icons.sentiment_dissatisfied_rounded,
                    size: 120,
                    color: resultColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    resultText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your result:',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[400]),
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
                  // Кнопка "Спробувати ще"
                  ElevatedButton.icon(
                    onPressed: () {
                      // Скидаємо результат
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
                  // Кнопка "На головну" (робить те саме, але виглядає інакше)
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
          // Віджет конфеті поверх усього
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            // Використовуємо наші змінні
            emissionFrequency: confettiEmissionFrequency,
            numberOfParticles: confettiNumberOfParticles,
            // Можна також додати гравітацію, щоб вони падали повільніше/швидше
            gravity: 0.1,
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
