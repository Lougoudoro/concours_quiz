/// Catégorie de concours pour le tableau de bord
library;

import 'package:flutter/material.dart';

class ConcourCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int totalQuestions;

  /// Progression de l'étudiant (0.0 à 1.0)
  final double progress;

  const ConcourCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.totalQuestions,
    this.progress = 0.0,
  });
}
