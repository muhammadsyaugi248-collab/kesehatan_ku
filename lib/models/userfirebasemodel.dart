import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Userfirebasemodel {
  String? uid;
  String? username;
  String? email;
  String? createdAt;
  String? updateAt;
  Userfirebasemodel({
    this.uid,
    this.username,
    this.email,
    this.createdAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory Userfirebasemodel.fromMap(Map<String, dynamic> map) {
    return Userfirebasemodel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updateAt: map['updateAt'] != null ? map['updateAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Userfirebasemodel.fromJson(String source) =>
      Userfirebasemodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
