/// Catégorie de concours pour le tableau de bord
library;

import 'package:cncours_quiz/app/data/resources/academic_session_resource.dart';
import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class BrandResource extends BaseResource {
  final String name;
  final String description;
  final String? logoUrl;
  final AcademicSessionResource? currentSession;

  /// Progression de l'étudiant (0.0 à 1.0)
  double progress = 0.0;

  BrandResource(
      {required super.id,
      required this.name,
      required this.description,
      required this.logoUrl,
      this.currentSession,
      super.createdAt,
      super.updatedAt});

  factory BrandResource.fromJson(Map<String, dynamic> json) {
    return BrandResource(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logo_url'],
      currentSession: json['current_session'] != null
          ? AcademicSessionResource.fromJson(json['current_session'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
