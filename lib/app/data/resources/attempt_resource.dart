
import 'package:cncours_quiz/app/data/resources/attempt_answer_resource.dart';
import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';

class AttemptResource  extends BaseResource{
  final Duration delay;
  final int? score;
  final int? totalPoints;
  final QuizResource? quiz;
  final List<AttemptAnswerResource> answers;

  AttemptResource({
    super.id,
    required this.delay,
    this.answers = const [],
    this.score,
    this.quiz,
    this.totalPoints,
    super.createdAt
  });

  factory AttemptResource.fromJson(Map<String, dynamic> json) => AttemptResource(
    id: json['id'],
        quiz: json['quiz'] != null ? QuizResource.fromJson( json['quiz'] ): null,
        answers: json['answers'] != null? (json['answers'] as List)
            .map((e) => AttemptAnswerResource.fromJson(e))
            .toList() : [],
        delay: Duration(seconds: json['delay'] ?? 0),
        totalPoints:json['total_points'],
        score: json['score'],
        createdAt: json['created_at'],
      );


  Map<String, dynamic> toJson() => {
        'id': id,
        'total_points':totalPoints,
        'score': score,
        'answers': answers.map((e) => e.toJson()).toList(),
        'delay': delay.inSeconds,
        'created_at': createdAt,
        'quiz': quiz?.toJson(),
      };
}
