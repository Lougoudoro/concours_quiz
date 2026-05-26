/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class QuizResource extends BaseResource {
  final String title;
  final String description;
  final int? questionsCount;

  /// Progression de l'étudiant (0.0 à 1.0)
  double progress = 0.0;

  QuizResource({
    required super.id,
    required this.title,
    required this.description,
    this.questionsCount
  });

  
  factory QuizResource.fromJson(Map<String, dynamic> json) => QuizResource(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        questionsCount: json['questions_count'] ?? 0,
      );

    @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'questions_count': questionsCount,
      };
}
