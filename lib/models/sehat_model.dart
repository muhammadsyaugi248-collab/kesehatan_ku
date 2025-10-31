import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StudentModel {
  int? id;
  String name;
  String email;
  String telephon;
  //int age;
  StudentModel({
    this.id,
    required this.name,
    required this.email,
    required this.telephon,
    //required this.age,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'class': telephon,
      //  'age': age,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      telephon: map['telephon'] as String,
      //  age: map['age'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
