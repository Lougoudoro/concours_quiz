import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/option_resource.dart';

class QuestionResource extends BaseResource {
  final String content;
  final String typeLabel;
  final String typeValue;
  final List<OptionResource> options;
  final String justification;

  QuestionResource({
    required super.id,
    required this.content,
    required this.typeLabel,
    required this.typeValue,
    required this.options,
    required this.justification,
  });

  factory QuestionResource.fromJson(Map<String, dynamic> json) =>
      QuestionResource(
        id: json['id'],
        content: json['content'],
        typeValue: json['type_value'],
        typeLabel: json['type_label'],
        options: (json['options'] as List)
            .map((o) => OptionResource.fromJson(o))
            .toList(),
        justification: json['justification'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'type_value': typeValue,
        'type_label': typeLabel,
        'options': options.map((o) => o.toJson()).toList(),
        'justification': justification,
      };

  bool get isVraiOuFaux => typeValue == 'vrai_ou_faux';
  bool get isQcm => typeValue == 'qcm';

  List<dynamic> get correctAnswerIds =>
      options.where((o) => o.isCorrect).map((o) => o.id).toList();
}
