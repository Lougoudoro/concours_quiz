import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/concours_type_resource.dart';

class AcademicSessionResource extends BaseResource {
  final String name;
  final bool isActive;
  final List<ConcoursTypeRecource> concoursTypes;

  AcademicSessionResource({
    required super.id,
    required this.name,
    required this.isActive,
    required this.concoursTypes
  });

  factory AcademicSessionResource.fromJson(Map<String, dynamic> json) => AcademicSessionResource(
        id: json['id'],
        name: json['name'],
        isActive: json['is_active'] ?? false,
        concoursTypes: (json['concours_types'] as List)
            .map((e) => ConcoursTypeRecource.fromJson(e))
            .toList()
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_active': isActive,
        'concours_types': concoursTypes.map((e) => e.toJson()).toList(),
      };
}
