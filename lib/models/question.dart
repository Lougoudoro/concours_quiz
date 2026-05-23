/// Modèle de données pour une question de quiz.
///
/// Supporte les QCM (choix multiples via Checkbox) et les Vrai/Faux.
/// Chaque question peut avoir PLUSIEURS bonnes réponses.
library;

/// Types de questions possibles
enum QuestionType {
  /// Question à Choix Multiples (plusieurs bonnes réponses possibles)
  qcm,

  /// Question Vrai ou Faux
  vraiOuFaux,
}

/// Représente une option de réponse
class AnswerOption {
  final String id;
  final String text;
  final bool isCorrect;

  const AnswerOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}

/// Représente une question complète avec ses options et sa justification
class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<AnswerOption> options;

  /// Justification affichée après validation (référence légale, explication, etc.)
  final String justification;

  /// Catégorie du concours (ENAREF, ENAM, Santé, etc.)
  final String category;

  const Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.justification,
    required this.category,
  });

  /// Retourne les IDs de toutes les bonnes réponses
  List<String> get correctAnswerIds =>
      options.where((o) => o.isCorrect).map((o) => o.id).toList();
}
