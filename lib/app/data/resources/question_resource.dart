import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/option_resource.dart';

class QuestionResource extends BaseResource {
  final String content;
  final String typeLabel;
  final String typeValue;
  final List<OptionResource> options;
  final String justification;
  final bool isVraiOuFaux;
final bool isQcm;
List<OptionResource>? _cachedShuffledOptions;

  QuestionResource({
    required super.id,
    required this.content,
    required this.typeLabel,
    required this.typeValue,
    required this.options,
    required this.justification,
    required this.isVraiOuFaux,
    required this.isQcm,
  });

  factory QuestionResource.fromJson(Map<String, dynamic> json) =>
      QuestionResource(
        id: json['id'],
        content: json['content'],
        typeValue: json['type_value'],
        typeLabel: json['type_label'],
        isVraiOuFaux: json['is_vrai_ou_faux'],
        isQcm: json['is_qcm'],
        options: (json['options'] as List)
            .map((o) => OptionResource.fromJson(o))
            .toList(),
        justification: json['justification'] ?? '',
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'type_value': typeValue,
        'type_label': typeLabel,
        'is_vrai_ou_faux':isVraiOuFaux,
        'is_qcm': isQcm,
        'options': options.map((o) => o.toJson()).toList(),
        'justification': justification,
      };

  List<dynamic> get correctAnswerIds =>
      options.where((o) => o.isCorrect).map((o) => o.id).toList();

    List<OptionResource> get shuffledOptions {
    // If not already shuffled, create and cache the shuffled list
    _cachedShuffledOptions ??= List<OptionResource>.from(options)..shuffle();
    return _cachedShuffledOptions!;
  }
}
