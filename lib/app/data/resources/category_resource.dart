/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';


class CategoryResource extends BaseResource {
  final String name;
  final String description;

  final List<SerieResource> series;

  CategoryResource({
    required super.id,
    required this.name,
    required this.description,
    this.series = const []
  });

  factory CategoryResource.fromJson(Map<String, dynamic> json) => CategoryResource(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        series: (json['series'] as List)
            .map((e) => SerieResource.fromJson(e))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description':description,
        'series':series.map((e) => e.toJson()).toList()
      };
}
