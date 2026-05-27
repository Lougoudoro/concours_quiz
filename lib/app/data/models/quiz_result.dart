import 'package:cncours_quiz/app/data/resources/question_resource.dart';

class QuestionResult {
  final QuestionResource question;
  final Set<int> userAnswerIds;

  QuestionResult({
    required this.question,
    required this.userAnswerIds,
  });

  bool get isCorrect {
    final correctIds = question.correctAnswerIds.toSet();
    return userAnswerIds.length == correctIds.length &&
        userAnswerIds.containsAll(correctIds);
  }

  factory QuestionResult.fromJson(Map<String, dynamic> json) => QuestionResult(
        question: QuestionResource.fromJson(json['question']),
        userAnswerIds: Set<int>.from(json['userAnswerIds']),
      );

  Map<String, dynamic> toJson() => {
        'question': question.toJson(),
        'userAnswerIds': userAnswerIds.toList(),
      };
}

class QuizResult {
  final String quizName;
  final List<QuestionResult> questionResults;
  final Duration totalTime;
  final DateTime dateTime;

  QuizResult({
    required this.quizName,
    required this.questionResults,
    required this.totalTime,
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
      );

  Map<String, dynamic> toJson() => {
        'quizName': quizName,
        'questionResults': questionResults.map((e) => e.toJson()).toList(),
        'totalSeconds': totalTime.inSeconds,
        'dateTime': dateTime.toIso8601String(),
      };
}
