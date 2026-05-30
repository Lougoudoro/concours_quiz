library;

import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:flutter/material.dart';
import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class SerieResource extends BaseResource {
  final String name;
  final String description;
  final IconData icon;
  final int? quizzesCount;
  final List<QuizResource> quizzes;

  double progress = 0.0;

  SerieResource({
    required super.id,
    required this.description,
    required this.name,
    required this.icon,
    this.quizzes = const [],
    this.quizzesCount,
    this.progress = 0.0,
  });

  factory SerieResource.fromJson(Map<String, dynamic> json) => SerieResource(
        id: json['id'],
        description: json['description'],
        name: json['name'],
        icon: Icons.book,
        quizzesCount: json['quizzes_count'] ?? 0,
        quizzes: (json['quizzes'] as List?)
                ?.map((o) => QuizResource.fromJson(o))
                .toList() ??
            [],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'name': name,
        'icon': icon.codePoint,
        'quizzes_count': quizzesCount,
        'quizzes': quizzes.map((o) => o.toJson()).toList(),
      };
}
