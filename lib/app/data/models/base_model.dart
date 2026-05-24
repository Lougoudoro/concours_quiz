// ignore_for_file: override_on_non_overriding_member

class BaseModel {
  int id;
  String? name;

  BaseModel({
    required this.id,
    this.name,
  });

  @override
  String toString() {
    return '{id: $id, name: $name}'; // Customize formatting as needed
  }

  static Map<String, dynamic> generateData(dynamic editing) {
    return {};
  }
}
