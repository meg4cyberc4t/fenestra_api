import 'dart:convert';

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

    router.post('/sign-up', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      UserStruct selectUser = UserStruct(
          id: null,
          firstName: input['first_name'],
          lastName: input['last_name'],
          login: input['login'],
          passwordHash: md5.convert(utf8.encode(input['password'])).toString());
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
        'authToken': authToken,
        'refreshToken': refreshToken,
      }));
    });

    // router.post('/sign-in', (Request request) async {
    //   dynamic input = jsonDecode(await request.readAsString());
    //   UserStruct selectUser = UserStruct.fromJson(json: input, id: -1, name: "");
    //   selectUser.passwordHash =
    //       md5.convert(utf8.encode(selectUser.passwordHash)).toString();
    //   selectUser.id = await repos.users.getIdByLogin(selectUser.login);
    //   if (selectUser.passwordHash !=
    //       (await repos.users.getFromId(selectUser.id)).passwordHash) {
    //     return Response(401);
    //   }
    //   String authToken = generateAuthToken(selectUser, serverSecretKey);
    //   String refreshToken = generateRefreshToken(selectUser, serverSecretKey);
    //   await repos.tokens.write(selectUser.id, refreshToken);
    //   return Response.ok(jsonEncode({
    //     'id': selectUser.id,
    //     'authToken': authToken,
    //     'refreshToken': refreshToken,
    //   }));
    // });

    // router.post('/reload-token', (Request request) async {
    //   dynamic input = jsonDecode(await request.readAsString());
    //   String token = input['refreshToken'];
    //   RefreshTokenStruct refreshToken = await repos.tokens.get(token);
    //   UserStruct selectUser = await repos.users.getFromId(refreshToken.ownerId);
    //   String authToken = generateAuthToken(selectUser, serverSecretKey);
    //   String newRefreshToken =
    //       generateRefreshToken(selectUser, serverSecretKey);
    //   await repos.tokens.rewrite(refreshToken.id, newRefreshToken);
    //   return Response.ok(jsonEncode({
    //     'id': selectUser.id,
    //     'authToken': authToken,
    //     'refreshToken': newRefreshToken
    //   }));
    // });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );

    return router;
  }
}
