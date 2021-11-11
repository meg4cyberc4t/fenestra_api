import 'package:uuid/uuid.dart';

class NotificationStruct {
  NotificationStruct({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.deadline,
    required this.repeat,
  });

  NotificationStruct.fromJson(Map<String, dynamic> json) {
    id = UuidValue(json['id']);
    title = json['title'];
    description = json['description'];
    owner = UuidValue(json['owner']);
    deadline = DateTime.fromMillisecondsSinceEpoch(json['deadline']);
    repeat = json['repeat'];
  }

  late UuidValue id;
  late String title;
  late String description;
  late UuidValue owner;
  late DateTime deadline;
  late int repeat;
}
