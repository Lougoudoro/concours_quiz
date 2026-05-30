/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/category_resource.dart';

class ConcoursTypeResource extends BaseResource {
  final String name;
  final String statusLabel;
  final String statusValue;
  final List<CategoryResource> categories;

  ConcoursTypeResource(
      {required super.id,
      required this.name,
      required this.statusValue,
      required this.statusLabel,
      this.categories = const []});

  factory ConcoursTypeResource.fromJson(Map<String, dynamic> json) =>
      ConcoursTypeResource(
          id: json['id'],
          name: json['name'],
          statusLabel: json['status_label'],
          statusValue: json['status_value'],
          categories: (json['categories'] as List)
              .map((e) => CategoryResource.fromJson(e))
              .toList());

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status_label': statusLabel,
        'status_value': statusValue,
        'categories': categories.map((e) => e.toJson()).toList()
      };
}
