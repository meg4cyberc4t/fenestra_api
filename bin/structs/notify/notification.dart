class NotificationStruct {
  NotificationStruct({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.deadline,
    required this.repeat,
    required this.folder,
  });

  NotificationStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    owner = json['owner'];
    deadline = json['deadline'];
    repeat = json['repeat'];
    folder = json['folder'];
  }

  Map toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "owner": owner,
        "deadline": deadline,
        "repeat": repeat,
        "folder": folder,
      };

  late int? id;
  late String title;
  late String? description;
  late int owner;
  late int? deadline;
  late int? repeat;
  late int? folder;
}
