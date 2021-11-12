class UserStruct {
  UserStruct({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.passwordHash,
    colleagues,
    subscribers,
    required this.color,
  })  : colleagues = colleagues ?? <int>[],
        subscribers = subscribers ?? <int>[];

  UserStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    login = json['login'];
    passwordHash = json['password'];
    colleagues = json['colleagues'] ?? <int>[];
    subscribers = json['subscribers'] ?? <int>[];
    color = json['color'];
  }

  late int? id;
  late String firstName;
  late String lastName;
  late String login;
  late String passwordHash;
  List<int> colleagues = <int>[];
  List<int> subscribers = <int>[];
  late int color;

  Map toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'login': login,
        'colleagues': colleagues,
        'subscribers': subscribers,
        'color': color,
      };
}
