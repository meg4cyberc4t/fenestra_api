// CREATE TABLE "notifications" (
// 	"id" uuid NOT NULL UNIQUE PRIMARY KEY,
// 	"title" varchar(255) NOT NULL,
// 	"description" varchar(255) NOT NULL,
// 	"owner" uuid NOT NULL,
// 	"deadline" TIMESTAMP WITH TIME ZONE NOT NULL,
// 	"repeat" smallint
// );

import 'package:uuid/uuid.dart';

class Folders {
  Folders({
    required this.id,
    required this.owner,
    required this.participants,
    required this.login,
    required this.description,
    required this.priority,
  });

  Folders.fromJson(Map<String, dynamic> json) {
    id = UuidValue(json['id']);
    owner = UuidValue(json['owner']);
    participants =
        json['participants'].map((dynamic value) => UuidValue(value)).toList();
    ;
    login = json['login'];
    description = json['description'];
    priority = json['priority'];
  }

  late UuidValue id;
  late UuidValue owner;
  late List<UuidValue> participants;
  late String login;
  late String description;
  late int priority;
}
