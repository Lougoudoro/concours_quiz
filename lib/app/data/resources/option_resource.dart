
import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class OptionResource extends BaseResource {
  final String content;
  final bool isCorrect;

  OptionResource({
    required super.id,
    required this.content,
    required this.isCorrect,
  });

  factory OptionResource.fromJson(Map<String, dynamic> json) => OptionResource(
        id: json['id'],
        content: json['text'],
        isCorrect: json['is_correct'] ?? false,
      );

    @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'is_correct': isCorrect,
      };
}