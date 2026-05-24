
import 'package:cncours_quiz/app/data/models/base_model.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends BaseModel{
  int? ruleId;
  String? name;
  dynamic forname;
  dynamic phone;
  String? email;
  dynamic emailVerifiedAt;
  String? status;

  UserModel(
      {required super.id,
      this.ruleId,
      this.name,
      this.forname,
      this.phone,
      this.email,
      this.emailVerifiedAt,
      this.status});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      ruleId: json['rule_id'],
      name: json['name'],
      forname: json['forname'],
      phone: json['phone'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['rule_id'] = ruleId;
    data['name'] = name;
    data['forname'] = forname;
    data['phone'] = phone;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['status'] = status;
    return data;
  }

  @override
  static Map<String, dynamic> generateData(UserModel? editing) {
    final data = <String, dynamic>{};
    data['id'] = editing?.id;
    data['name'] = TextEditingController(text: editing?.name);
    data['forname'] = TextEditingController(text: editing?.forname);
    data['phone'] = TextEditingController(text: editing?.phone);
    data['email'] = TextEditingController(text: editing?.email);
    data['email_verified_at'] = TextEditingController(text: editing?.emailVerifiedAt);
    data['status'] = TextEditingController(text: editing?.status);
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}'; // Customize formatting as needed
  }
}
