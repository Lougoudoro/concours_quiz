/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/attempt_resource.dart';
import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:flutter/material.dart';

class QuizResource extends BaseResource {
  final String title;
  final String description;
  final String typeLabel;
  final String typeValue;
  final bool isExam;
  final bool isSimple;
  final int? duration;
  @protected
  final int? questionsCount;
  final List<QuestionResource> questions;
  final AttemptResource? userAttempt;

  double progress = 0.0;

  QuizResource({
    required super.id,
    required this.title,
    required this.description,
    required this.typeLabel,
    required this.typeValue,
    required this.isExam,
    required this.isSimple,
    this.userAttempt,
    this.duration,
    this.questions = const [],
    this.questionsCount,
  });

  factory QuizResource.fromJson(Map<String, dynamic> json) => QuizResource(
        id: json['id'],
        title: json['title'],
        typeValue: json['type_value'],
        typeLabel: json['type_label'],
        isExam: json['is_exam'],
        isSimple: json['is_simple'],
        description: json['description'],
        duration: json['duration'],
        userAttempt:json['user_attempt'] != null? AttemptResource.fromJson(json['user_attempt']) : null,
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
        'duration': duration,
        'type_value': typeValue,
        'type_label': typeLabel,
        'is_simple': isSimple,
        'is_exam': isExam,
        'questions_count': questionsCount,
        'questions': questions.map((o) => o.toJson()).toList(),
        'user_attempt': userAttempt?.toJson()
      };

    int get getQuesionsCount => questionsCount??questions.length;
    bool get hasUserAttempt => userAttempt!=null;
}
