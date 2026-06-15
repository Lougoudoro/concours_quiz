import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';

class AttemptAnswerResource  extends BaseResource {
  final int successCount;
  final QuestionResource question;
  final Set<int> userResponseIds;

  AttemptAnswerResource({
    super.id,
    required this.successCount,
    required this.question,
    required this.userResponseIds,
  });

  factory AttemptAnswerResource.fromJson(Map<String, dynamic> json) => AttemptAnswerResource(
        id: json['id'],
        successCount: json['success_count'],
        question: QuestionResource.fromJson(json['question']),
        userResponseIds: Set<int>.from(json['user_response_ids']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'success_count': successCount,
        'question': question.toJson(),
        'user_response_ids': userResponseIds.toList(),
      };
}
