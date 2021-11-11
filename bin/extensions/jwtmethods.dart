import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../structs/user.dart';

String generateAuthToken(UserStruct user, String secretServerKey) {
  final jwt = JWT({
    'id': user.id,
    'exp': DateTime.now().add(Duration(minutes: 15)).millisecondsSinceEpoch ~/
        1000,
    'type': 'auth',
  });
  return jwt.sign(SecretKey(secretServerKey));
}

String generateRefreshToken(UserStruct user, String secretServerKey) {
  final jwt = JWT({
    'id': user.id,
    'exp':
        DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch ~/ 1000,
    'type': 'refresh',
  });
  return jwt.sign(SecretKey(secretServerKey));
}
