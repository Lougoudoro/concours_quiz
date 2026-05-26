/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';


class CategoryResource extends BaseResource {
  final String name;
  final String description;

  /// Progression de l'étudiant (0.0 à 1.0)
  final double progress;

  CategoryResource({
    required super.id,
    required this.name,
    required this.description,
    this.progress = 0.0,
  });

  factory CategoryResource.fromJson(Map<String, dynamic> json) => CategoryResource(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        progress: json['progress']??0.0,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description':description,
        'progress':progress
      };
}
