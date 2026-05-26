import 'package:cncours_quiz/app/data/resources/question_resource.dart';

class Session {
  final int id;
  final String name;
  final bool isActive;
  final List<ConcoursType> concoursTypes;

  Session({
    required this.id,
    required this.name,
    required this.isActive,
    required this.concoursTypes,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        name: json['name'],
        isActive: json['isActive'] ?? false,
        concoursTypes: (json['concoursTypes'] as List)
            .map((e) => ConcoursType.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isActive': isActive,
        'concoursTypes': concoursTypes.map((e) => e.toJson()).toList(),
      };
}

enum ConcoursCategory { direct, professionnel }

class ConcoursType {
  final int id;
  final String name; // e.g. "Directs" or "Professionnels"
  final ConcoursCategory category;
  final List<SubCategory> subCategories; // Levels for direct, Sectors for pro

  ConcoursType({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategories,
  });

  factory ConcoursType.fromJson(Map<String, dynamic> json) => ConcoursType(
        id: json['id'],
        name: json['name'],
        category: ConcoursCategory.values
            .firstWhere((e) => e.toString() == json['category']),
        subCategories: (json['subCategories'] as List)
            .map((e) => SubCategory.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.toString(),
        'subCategories': subCategories.map((e) => e.toJson()).toList(),
      };
}

class SubCategory {
  final int id;
  final String name; // e.g. "BAC", "Licence" or "ENAM", "Santé"
  final List<Collection> collections;

  SubCategory({
    required this.id,
    required this.name,
    required this.collections,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json['id'],
        name: json['name'],
        collections: (json['collections'] as List)
            .map((e) => Collection.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'collections': collections.map((e) => e.toJson()).toList(),
      };
}

class Collection {
  final int id;
  final String name; // e.g. "Formation de Janvier"
  final List<Serie> series;

  Collection({
    required this.id,
    required this.name,
    required this.series,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json['id'],
        name: json['name'],
        series: (json['series'] as List).map((e) => Serie.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'series': series.map((e) => e.toJson()).toList(),
      };
}

class Serie {
  final int id;
  final String name; // e.g. "Quiz 1", "Examen Blanc"
  final List<QuestionResource> questions;

  Serie({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory Serie.fromJson(Map<String, dynamic> json) => Serie(
        id: json['id'],
        name: json['name'],
        questions: (json['questions'] as List)
            .map((e) => QuestionResource.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'questions': questions.map((e) => e.toJson()).toList(),
      };
}
