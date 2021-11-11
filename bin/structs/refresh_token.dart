import 'package:uuid/uuid.dart';

class RefreshToken {
  RefreshToken({
    required this.id,
    required this.owner,
    required this.token,
  });

  RefreshToken.fromJson(Map<String, dynamic> json) {
    id = UuidValue(json['id']);
    owner = UuidValue(json['owner']);
    token = json['token'];
  }

  late UuidValue id;
  late UuidValue owner;
  late String token;
}
