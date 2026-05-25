import 'package:cncours_quiz/app/data/resources/base_resource.dart';

import 'package:flutter/cupertino.dart';

class AuthResource extends BaseResource{
  String? email;
  String? name;

  AuthResource(
      {required super.id,
      this.name,
      this.email
      });

  factory AuthResource.fromJson(Map<String, dynamic> json) {
    return AuthResource(
      id: json['id'],
      name: json['name'],
      email: json['email']
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }

  @override
  static Map<String, dynamic> generateData(AuthResource? editing) {
    final data = <String, dynamic>{};
    data['id'] = editing?.id;
    data['name'] = TextEditingController(text: editing?.name);
    data['email'] = TextEditingController(text: editing?.email);
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}'; // Customize formatting as needed
  }
}
