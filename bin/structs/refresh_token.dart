class RefreshToken {
  RefreshToken({
    required this.id,
    required this.ownerId,
    required this.token,
  });

  RefreshToken.fromJson(
      {required Map<String, dynamic> json, id, ownerId, token}) {
    this.id = id ?? json['id'];
    this.ownerId = ownerId ?? json['owner_id'];
    this.token = token ?? json['token'];
  }

  late int id;
  late int ownerId;
  late String token;

  Map toMap() {
    return {"id": id, "owner_id": ownerId, "token": token};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
