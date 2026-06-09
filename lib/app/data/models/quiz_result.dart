import 'package:cncours_quiz/app/data/models/question_result.dart';

class QuizResult {
  final String quizName;
  final List<QuestionResult> questionResults;
  final Duration totalTime;
  final DateTime dateTime;
  final int quizId;

  QuizResult({
    required this.quizName,
    required this.questionResults,
    required this.totalTime,
    required this.quizId,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  int get score => questionResults.where((r) => r.isCorrect).length;
  int get total => questionResults.length;
  double get percentage => total > 0 ? (score / total) * 100 : 0;

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        quizName: json['quizName'],
        questionResults: (json['questionResults'] as List)
            .map((e) => QuestionResult.fromJson(e))
            .toList(),
        totalTime: Duration(seconds: json['totalSeconds'] ?? 0),
        dateTime:
            json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
        quizId: json['quizId'] as int,
      );

  Map<String, dynamic> toJson() => {
        'quizName': quizName,
        'questionResults': questionResults.map((e) => e.toJson()).toList(),
        'totalSeconds': totalTime.inSeconds,
        'dateTime': dateTime.toIso8601String(),
        'quizId': quizId,
      };

      
  Map<String, dynamic> toRequestBody() => {
        'delay': totalTime.inMinutes,
        'answers': questionResults.map((e) => e.toRequestBody()).toList(),
      };
}
