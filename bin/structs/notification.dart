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
    id = json['id'];
    title = json['title'];
    description = json['description'];
    owner = json['owner'];
    deadline = DateTime.fromMillisecondsSinceEpoch(json['deadline']);
    repeat = json['repeat'];
  }

  late String id;
  late String title;
  late String description;
  late String owner;
  late DateTime deadline;
  late int repeat;
}
