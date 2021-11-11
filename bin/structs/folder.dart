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
    participants = json['participants'];
    login = json['login'];
    description = json['description'];
    priority = json['priority'];
  }

  late int id;
  late int owner;
  late List<int> participants;
  late String login;
  late String description;
  late int priority;
}
