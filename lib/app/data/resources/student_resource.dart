import 'package:cncours_quiz/app/data/resources/base_resource.dart';

class StudentResource extends BaseResource {
  String? matricule;
  String? firstname;
  String? lastname;
  String? birthday;
  String? brithplace;
  String? sexLabel;

  StudentResource({
    required super.id,
    this.matricule,
    this.firstname,
    this.lastname,
    this.birthday,
    this.brithplace,
    this.sexLabel,
  });

  factory StudentResource.fromJson(Map<String, dynamic> json) {
    return StudentResource(
      id: json['id'],
      matricule: json['matricule'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      birthday: json['birth_day'],
      brithplace: json['brith_place'],
      sexLabel: json['sex'],
    );
  }

  @override
  String toString() {
    return 'StudentResource{id: $id, matricule: $matricule}'; // Customize formatting as needed
  }
}
