import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserStruct {
  UserStruct({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.passwordHash,
    colleagues,
    subscribers,
    photo,
    photo200,
  })  : colleagues = colleagues ?? <String>[],
        subscribers = subscribers ?? <String>[],
        photo = photo ?? "",
        photo200 = photo200 ?? "";

  UserStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    login = json['login'];
    passwordHash = json['password'];
    colleagues = json['colleagues'] ?? [];
    subscribers = json['subscribers'] ?? [];
    photo = json['photo'] ?? "";
    photo200 = json['photo200'] ?? "";
  }

  late String? id;
  late String firstName;
  late String lastName;
  late String login;
  late String passwordHash;
  List<String> colleagues = <String>[];
  List<String> subscribers = <String>[];
  String photo = "";
  String photo200 = "";
}
