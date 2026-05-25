class BaseResource {
  int id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  BaseResource({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'BaseResource{id: $id}'; // Customize formatting as needed
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return data;
  }
}
