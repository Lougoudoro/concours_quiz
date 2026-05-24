class BaseResource {
  int id;
  String? label;
  bool isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  BaseResource({
    required this.id,
    this.label,
    this.isActive=true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $label}'; // Customize formatting as needed
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return data;
  }
}
