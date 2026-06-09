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

  Map<String, dynamic> toRequestBody() => {
        'question_id': question.id,
        'user_response_ids': userAnswerIds.toList(),
      };
}
