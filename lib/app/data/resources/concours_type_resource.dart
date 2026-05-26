/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/base_resource.dart';


class ConcoursTypeRecource extends BaseResource {
  final String name;
  final String statusLabel;
  final String statusValue;

  ConcoursTypeRecource({
    required super.id,
    required this.name,
    required this.statusValue,
    required this.statusLabel,
  });

  factory ConcoursTypeRecource.fromJson(Map<String, dynamic> json) => ConcoursTypeRecource(
        id: json['id'],
        name: json['name'],
        statusLabel: json['status_label'],
        statusValue: json['status_value'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status_label':statusLabel,
        'status_value':statusLabel
      };
}
