enum QuestionType { qcm, vraiOuFaux }

class AnswerOption {
  final String id;
  final String text;
  final bool isCorrect;

  const AnswerOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
        id: json['id'],
        text: json['text'],
        isCorrect: json['isCorrect'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCorrect': isCorrect,
      };
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<AnswerOption> options;
  final String justification;
  final String category;

  const Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.justification,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        text: json['text'],
        type: QuestionType.values.firstWhere((e) => e.toString() == json['type']),
        options: (json['options'] as List)
            .map((o) => AnswerOption.fromJson(o))
            .toList(),
        justification: json['justification'] ?? '',
        category: json['category'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'type': type.toString(),
        'options': options.map((o) => o.toJson()).toList(),
        'justification': justification,
        'category': category,
      };

  List<String> get correctAnswerIds =>
      options.where((o) => o.isCorrect).map((o) => o.id).toList();
}
