/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class SerieResource extends BaseResource {
  final String name;
  final String description;
  final int? quizzesCount;

  /// Progression de l'étudiant (0.0 à 1.0)
  double progress = 0.0;

  SerieResource({
    required super.id,
    required this.description,
    required this.name,
    this.quizzesCount
  });

  
  factory SerieResource.fromJson(Map<String, dynamic> json) => SerieResource(
        id: json['id'],
        description: json['description'],
        name: json['name'],
        quizzesCount: json['quizzes_count'] ?? 0,
      );

    @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'name': name,
        'quizzes_count': quizzesCount,
      };
}
