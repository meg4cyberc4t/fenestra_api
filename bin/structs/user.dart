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
  })  : colleagues = colleagues ?? <int>[],
        subscribers = subscribers ?? <int>[],
        photo = photo ?? "",
        photo200 = photo200 ?? "";

  UserStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    login = json['login'];
    passwordHash = json['password'];
    colleagues = json['colleagues'] ?? <int>[];
    subscribers = json['subscribers'] ?? <int>[];
    photo = json['photo'] ?? "";
    photo200 = json['photo200'] ?? "";
  }

  late int? id;
  late String firstName;
  late String lastName;
  late String login;
  late String passwordHash;
  List<int> colleagues = <int>[];
  List<int> subscribers = <int>[];
  String photo = "";
  String photo200 = "";

  Map toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'login': login,
        'colleagues': colleagues,
        'subscribers': subscribers,
        'photo': photo,
        'photo200': photo200,
      };
}
