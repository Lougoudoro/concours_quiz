import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class LevelResource extends BaseResource {
  String? statusLabel;

  LevelResource(
      {required super.id,
      super.label,
      this.statusLabel,
        super.isActive,
      super.createdAt,
      super.updatedAt,
      super.deletedAt});

  factory LevelResource.fromJson(Map<String, dynamic> json) {
    return LevelResource(
      id: json['id'],
      label: json['label'],
      isActive: json['is_active'],
      statusLabel: json['status_label'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

}
