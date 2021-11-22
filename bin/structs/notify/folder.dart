class FolderStruct {
  FolderStruct({
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.priority,
  });

  FolderStruct.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    title = json['title'];
    description = json['description'];
    priority = json['priority'];
  }

  late int? id;
  late int owner;
  late String title;
  late String? description;
  late int priority;

  Map toMap() => {
        'id': id,
        'owner': owner,
        'title': title,
        'description': description,
        'priority': priority,
      };
}
