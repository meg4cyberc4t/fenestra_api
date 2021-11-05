import 'structs/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const secretServerKey = "ALOHAMORA";

String generateAuthToken(User user) {
  final jwt = JWT(
    {
      'id': user.id,
      'exp': DateTime.now().add(Duration(minutes: 15)).millisecondsSinceEpoch ~/
          1000,
      'type': 'auth',
    },
    issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
  );
  return jwt.sign(SecretKey(secretServerKey));
}

String generateRefreshToken(User user) {
  final jwt = JWT(
    {
      'id': user.id,
      'exp':
          DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch ~/ 1000,
      'type': 'refresh',
    },
    issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
  );
  return jwt.sign(SecretKey(secretServerKey));
}
