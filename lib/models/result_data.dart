import 'package:flutter/material.dart';

class ResultData {
  final String text;
  final Color color;
  final IconData icon;
  final double confettiEmission;
  final int confettiParticles;
  final bool shouldPlayConfetti;

  ResultData({
    required this.text,
    required this.color,
    required this.icon,
    required this.confettiEmission,
    required this.confettiParticles,
    required this.shouldPlayConfetti,
  });
}