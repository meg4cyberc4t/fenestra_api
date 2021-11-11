import 'package:uuid/uuid.dart';

class UserStruct {
  UserStruct({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.passwordHash,
    required this.colleagues,
    required this.subscribers,
    required this.photo,
    required this.photo200,
  });

  UserStruct.fromJson(Map<String, dynamic> json) {
    id = UuidValue(json['id']);
    firstName = json['first_name'];
    lastName = json['last_name'];
    login = json['login'];
    passwordHash = json['password_hash'];
    colleagues =
        json['colleagues'].map((dynamic value) => UuidValue(value)).toList();
    ;
    subscribers =
        json['subscribers'].map((dynamic value) => UuidValue(value)).toList();
    ;
    photo = json['photo'];
    photo200 = json['photo200'];
  }

  late UuidValue id;
  late String firstName;
  late String lastName;
  late String login;
  late String passwordHash;
  late List<UuidValue> colleagues;
  late List<UuidValue> subscribers;
  late String photo;
  late String photo200;
}
