import 'package:cncours_quiz/app/data/resources/base_resource.dart';
import 'package:cncours_quiz/app/data/resources/brand_resource.dart';
import 'package:cncours_quiz/app/data/resources/concours_type_resource.dart';

class AcademicSessionResource extends BaseResource {
  final String name;
  final bool isActive;
  final List<ConcoursTypeResource> concoursTypes;
  final BrandResource? brand;

  AcademicSessionResource({
    required super.id,
    required this.name,
    required this.isActive,
    required this.concoursTypes,
    this.brand
  });

  factory AcademicSessionResource.fromJson(Map<String, dynamic> json) => AcademicSessionResource(
        id: json['id'],
        name: json['name'],
        isActive: json['is_active'] ?? false,
        brand: json['brand']!=null ? BrandResource.fromJson(json['brand']) : null,
        concoursTypes: (json['concours_types'] as List)
            .map((e) => ConcoursTypeResource.fromJson(e))
            .toList()
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_active': isActive,
        'brand':brand?.toJson(),
        'concours_types': concoursTypes.map((e) => e.toJson()).toList(),
      };
}
