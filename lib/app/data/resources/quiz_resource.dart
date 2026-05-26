/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';

class QuizResource extends BaseResource {
  final String title;
  final String description;
  final int? questionsCount;
  final List<QuestionResource> questions;

  double progress = 0.0;

  QuizResource({
    required super.id,
    required this.title,
    required this.description,
    this.questions = const [],
    this.questionsCount,
  });

  factory QuizResource.fromJson(Map<String, dynamic> json) => QuizResource(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        questionsCount: json['questions_count'] ?? 0,
        questions: (json['questions'] as List?)
                ?.map((o) => QuestionResource.fromJson(o))
                .toList() ??
            [],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'questions_count': questionsCount,
        'questions': questions.map((o) => o.toJson()).toList(),
      };
}
