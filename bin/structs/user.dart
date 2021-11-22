class UserStruct {
  UserStruct({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.passwordHash,
    colleagues,
    subscribers,
    subscriptions,
    required this.color,
  });

  UserStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    login = json['login'];
    passwordHash = json['password'];
    color = json['color'];
  }

  late int? id;
  late String firstName;
  late String lastName;
  late String login;
  late String passwordHash;
  late int color;

  Map toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'login': login,
        'color': color,
      };
}
