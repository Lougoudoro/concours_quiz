/// Modèle de résultat pour chaque question répondue.
///
/// Conserve les réponses de l'utilisateur et les compare aux bonnes réponses
/// pour calculer le score et afficher la correction.
library;

import 'question.dart';

/// Résultat d'une question individuelle
class QuestionResult {
  final Question question;
  final Set<String> userAnswerIds;

  const QuestionResult({
    required this.question,
    required this.userAnswerIds,
  });

  /// Vérifie si l'utilisateur a répondu correctement
  /// (toutes les bonnes réponses cochées ET aucune mauvaise)
  bool get isCorrect {
    final correctIds = question.correctAnswerIds.toSet();
    return userAnswerIds.length == correctIds.length &&
        userAnswerIds.containsAll(correctIds);
  }
}

/// Résultat global d'un quiz complet
class QuizResult {
  final String categoryName;
  final List<QuestionResult> questionResults;
  final Duration totalTime;

  const QuizResult({
    required this.categoryName,
    required this.questionResults,
    required this.totalTime,
  });

  /// Score : nombre de questions entièrement correctes
  int get score => questionResults.where((r) => r.isCorrect).length;

  /// Nombre total de questions
  int get total => questionResults.length;

  /// Pourcentage de réussite
  double get percentage => total > 0 ? (score / total) * 100 : 0;
}
