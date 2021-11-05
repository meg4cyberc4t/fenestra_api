class User {
  User({
    required this.id,
    required this.name,
    required this.login,
    required this.passwordHash,
  });

  User.fromJson(
      {required Map<String, dynamic> json, id, login, name, passwordHash}) {
    this.id = id ?? json['id'];
    this.login = login ?? json['login'];
    this.name = name ?? json['name'];
    this.passwordHash = passwordHash ?? json['password'];
  }

  late int id;
  late String name;
  late String login;
  late String passwordHash;

  Map toMap() {
    return {"id": id, "name": name, "login": login, "password": passwordHash};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
