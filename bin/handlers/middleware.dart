import 'dart:convert';

import '../structs/error.dart';
import '../structs/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

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

Middleware handleAuth(String secret) {
  return (Handler innerHandler) {
    return (Request request) async {
      String? token = request.headers['Authorization'];
      if (token == null) {
        return Response.ok(jsonEncode(ApiError.unauthorized.toMap()));
      }
      if (token.startsWith('Bearer ')) {
        token = token.substring(7);
      }
      try {
        JWT jwt = JWT.verify(token, SecretKey(secretServerKey));
        final updatedRequest =
            request.change(context: {'id': jwt.payload['id']});
        return await innerHandler(updatedRequest);
      } on JWTExpiredError {
        return Response.ok(jsonEncode(ApiError.tokenExpired.toMap()));
      } catch (e) {
        print(e);
        return Response.ok(jsonEncode(ApiError.unauthorized.toMap()));
      }
    };
  };
}
