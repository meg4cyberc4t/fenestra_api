import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

Middleware handleAuth(String secret) {
  return (Handler innerHandler) {
    return (Request request) async {
      final Request updatedRequest;
      try {
        String token = request.headers['Authorization']!;
        if (token.startsWith('Bearer ')) {
          token = token.substring(7);
        }
        JWT jwt = JWT.verify(token, SecretKey(secret));
        updatedRequest = request.change(context: {'id': jwt.payload['id']});
      } catch (e) {
        print('handleAuth: $e');
        return Response(401);
      }
      return await innerHandler(updatedRequest);
    };
  };
}

Middleware handleErrors() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (e) {
        print("handleErrors: $e");
        return Response(403);
      }
    };
  };
}

Middleware setJsonHeader() {
  return (Handler innerHandler) {
    return (Request request) async {
      return await innerHandler(
          request.change(headers: {"Content-Type": 'application/json'}));
    };
  };
}
