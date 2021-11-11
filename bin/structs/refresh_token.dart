class RefreshTokenStruct {
  RefreshTokenStruct({
    required this.id,
    required this.owner,
    required this.token,
  });

  RefreshTokenStruct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    token = json['token'];
  }

  late int? id;
  late int owner;
  late String token;
}
