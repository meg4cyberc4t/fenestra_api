import 'dart:convert';

import '../extensions/check_correct_login.dart';
import '../extensions/jwtmethods.dart';
import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../structs/refresh_token.dart';
import '../structs/user.dart';
import 'package:crypto/crypto.dart';

class AuthHandlers {
  const AuthHandlers(this.repos, this.serverSecretKey);
  final Repository repos;
  final String serverSecretKey;

  Router get router {
    final router = Router();

    router.post('/signUp', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      UserStruct selectUser = UserStruct(
        id: null,
        firstName: input['first_name'],
        lastName: input['last_name'],
        login: input['login'],
        passwordHash: md5.convert(utf8.encode(input['password'])).toString(),
        color: input['color'],
      );
      try {
        await repos.users.add(selectUser);
      } catch (e) {
        print(e);
        return Response(422);
      }
      String authToken = generateAuthToken(selectUser, serverSecretKey);
      String refreshToken = generateRefreshToken(selectUser, serverSecretKey);
      await repos.refreshTokens.write(RefreshTokenStruct(
          id: null, owner: selectUser.id!, token: refreshToken));
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'auth_token': authToken,
        'refresh_token': refreshToken,
      }));
    });

    router.post('/signIn', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      int id = await repos.users.getIdFromLoginPassword(input['login'],
          md5.convert(utf8.encode(input['password'])).toString());
      UserStruct user = await repos.users.getFromId(id);
      String authToken = generateAuthToken(user, serverSecretKey);
      String refreshToken = generateRefreshToken(user, serverSecretKey);
      await repos.refreshTokens.write(RefreshTokenStruct(
        id: null,
        owner: user.id!,
        token: refreshToken,
      ));
      return Response.ok(jsonEncode({
        'id': user.id,
        'auth_token': authToken,
        'refresh_token': refreshToken,
      }));
    });

    router.post('/reloadToken', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      RefreshTokenStruct refreshToken =
          await repos.refreshTokens.get(input['refresh_token']);
      UserStruct selectUser = await repos.users.getFromId(refreshToken.owner);
      String authToken = generateAuthToken(selectUser, serverSecretKey);
      refreshToken.token = generateRefreshToken(selectUser, serverSecretKey);
      await repos.refreshTokens.rewrite(refreshToken);
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'auth_token': authToken,
        'refresh_token': refreshToken.token
      }));
    });

    router.post('/checkCorrectLogin', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      String login = input['login'];
      if (!checkCorrectLogin(login)) {
        return Response(403);
      }
      if (!await repos.users.isUniqueLogin(login)) {
        return Response(422);
      }
      return Response(202);
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(''),
    );

    return router;
  }
}
