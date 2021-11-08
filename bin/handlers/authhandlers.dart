import '../extensions/jwtmethods.dart';
import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../structs/refresh_token.dart';
import '../structs/user.dart';

class AuthHandlers {
  AuthHandlers(this.repos, this.defaultHeaders);
  final Repository repos;
  final Map<String, String> defaultHeaders;

  Router get router {
    final router = Router();

    router.post('/sign-up', (Request request) async {
      late User selectUser;
      dynamic input = jsonDecode(await request.readAsString());
      selectUser = User.fromJson(json: input, id: -1);
      selectUser.passwordHash =
          md5.convert(utf8.encode(selectUser.passwordHash)).toString();
      if (!await repos.users.checkUniqueLogin(selectUser.login)) {
        return Response(422);
      }
      await repos.users.add(selectUser);
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      await repos.tokens.write(selectUser.id, refreshToken);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'authToken': authToken,
        'refreshToken': refreshToken,
      }));
    });

    router.post('/sign-in', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      User selectUser = User.fromJson(json: input, id: -1, name: "");
      selectUser.passwordHash =
          md5.convert(utf8.encode(selectUser.passwordHash)).toString();
      selectUser.id = await repos.users.getIdByLogin(selectUser.login);
      if (selectUser.passwordHash !=
          (await repos.users.getFromId(selectUser.id)).passwordHash) {
        return Response(401);
      }
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      await repos.tokens.write(selectUser.id, refreshToken);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'authToken': authToken,
        'refreshToken': refreshToken,
      }));
    });

    router.post('/reload-token', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      String token = input['refreshToken'];
      RefreshToken refreshToken = await repos.tokens.get(token);
      User selectUser = await repos.users.getFromId(refreshToken.ownerId);
      String authToken = generateAuthToken(selectUser);
      String newRefreshToken = generateRefreshToken(selectUser);
      await repos.tokens.rewrite(refreshToken.id, newRefreshToken);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'authToken': authToken,
        'refreshToken': newRefreshToken
      }));
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );

    return router;
  }
}
