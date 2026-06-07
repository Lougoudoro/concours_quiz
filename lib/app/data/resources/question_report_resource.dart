import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class QuestionReportResource extends BaseResource {
  final int userId;
  final int questionId;
  final String message;
  final String status;

  QuestionReportResource({
    required super.id,
    required this.userId,
    required this.questionId,
    required this.message,
    required this.status,
  });

  factory QuestionReportResource.fromJson(Map<String, dynamic> json) =>
      QuestionReportResource(
        id: json['id'],
        userId: json['user_id'],
        questionId: json['question_id'],
        message: json['message'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'question_id': questionId,
        'message': message,
        'status': status,
      };
}
