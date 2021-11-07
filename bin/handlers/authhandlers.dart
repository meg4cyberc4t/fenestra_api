import '../extensions/jwtmethods.dart';
import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
      if (!await repos.checkUniqueLogin(selectUser.login)) {
        return Response(422);
      }
      await repos.addNewUser(selectUser);
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      repos.writeRefreshToken(selectUser, refreshToken);
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
      if (await repos.checkUniqueLogin(selectUser.login)) {
        return Response(422);
      }
      selectUser.id = await repos.getIdByLogin(selectUser.login);
      if (selectUser.passwordHash !=
          await repos.getPasswordHashById(selectUser.id)) {
        return Response(401);
      }
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      repos.writeRefreshToken(selectUser, refreshToken);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'authToken': authToken,
        'refreshToken': refreshToken,
      }));
    });

    router.post('/reload-token', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      String refreshToken = input['refreshToken'];
      int refreshTokenId =
          await repos.getIdRefreshTokenByRefreshToken(refreshToken);
      int ownerId = await repos.getOwnerIdByRefreshToken(refreshToken);
      User selectUser = await repos.getUserfromId(ownerId);
      String authToken = generateAuthToken(selectUser);
      String newRefreshToken = generateRefreshToken(selectUser);
      repos.rewriteRefreshTokenByRefreshTokenId(
          newRefreshToken, refreshTokenId);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'authToken': authToken,
        'refreshToken': refreshToken,
      }));
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );

    return router;
  }
}
