import 'package:uuid/uuid.dart';

class FolderStruct {
  FolderStruct({
    required this.id,
    required this.owner,
    required this.participants,
    required this.login,
    required this.description,
    required this.priority,
  });

  FolderStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    participants =
        json['participants'].map((dynamic value) => UuidValue(value)).toList();

    login = json['login'];
    description = json['description'];
    priority = json['priority'];
  }

  late String id;
  late String owner;
  late List<String> participants;
  late String login;
  late String description;
  late int priority;
}
