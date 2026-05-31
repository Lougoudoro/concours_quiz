import 'package:cncours_quiz/app/data/resources/base_resource.dart';


class AuthResource extends BaseResource {
  String? email;
  String? name;
  String? profilePhotoUrl;

  AuthResource(
      {required super.id, this.name, this.email, this.profilePhotoUrl});

  factory AuthResource.fromJson(Map<String, dynamic> json) {
    return AuthResource(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        profilePhotoUrl: json['profile_photo_url']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profile_photo_url'] = profilePhotoUrl;
    return data;
  }


  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}'; // Customize formatting as needed
  }
}
