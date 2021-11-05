import '../structs/error.dart';
import '../repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../middleware.dart';

import '../structs/reponse.dart';
import '../structs/user.dart';

class AuthHandlers {
  AuthHandlers(this.repos, this.defaultHeaders);
  final Repository repos;
  final Map<String, String> defaultHeaders;

  Router get router {
    final router = Router();

    router.post('/sign-up', (Request request) async {
      late User selectUser;
      try {
        dynamic input = jsonDecode(await request.readAsString());
        selectUser = User.fromJson(json: input, id: -1);
      } catch (e) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }

      selectUser.passwordHash =
          md5.convert(utf8.encode(selectUser.passwordHash)).toString();

      if (!await repos.checkUniqueLogin(selectUser.login)) {
        return Response.ok(jsonEncode(ApiError.notUniqueValue.toMap()),
            headers: defaultHeaders);
      }
      await repos.addNewUser(selectUser);
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      repos.writeRefreshToken(selectUser, refreshToken);
      return Response.ok(
          jsonEncode(ApiResponse({
            'id': selectUser.id,
            'authToken': authToken,
            'refreshToken': refreshToken,
          }).toMap()),
          headers: defaultHeaders);
    });

    router.post('/sign-in', (Request request) async {
      late User selectUser;
      try {
        dynamic input = jsonDecode(await request.readAsString());
        selectUser = User.fromJson(json: input, id: -1, name: "");
      } catch (e) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }
      selectUser.passwordHash =
          md5.convert(utf8.encode(selectUser.passwordHash)).toString();

      if (await repos.checkUniqueLogin(selectUser.login)) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }
      selectUser.id = await repos.getIdByLogin(selectUser.login);
      if (selectUser.passwordHash !=
          await repos.getPasswordHashById(selectUser.id)) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }
      String authToken = generateAuthToken(selectUser);
      String refreshToken = generateRefreshToken(selectUser);
      repos.writeRefreshToken(selectUser, refreshToken);
      return Response.ok(
          jsonEncode(ApiResponse({
            'id': selectUser.id,
            'authToken': authToken,
            'refreshToken': refreshToken,
          }).toMap()),
          headers: defaultHeaders);
    });

    router.post('/reload-token', (Request request) async {
      late String refreshToken;
      try {
        dynamic input = jsonDecode(await request.readAsString());
        refreshToken = input['refreshToken'];
      } catch (e) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }
      late int refreshTokenId;
      late int ownerId;
      try {
        refreshTokenId =
            await repos.getIdRefreshTokenByRefreshToken(refreshToken);
        ownerId = await repos.getOwnerIdByRefreshToken(refreshToken);
      } catch (e) {
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()),
            headers: defaultHeaders);
      }
      User selectUser = await repos.getUserfromId(ownerId);
      String authToken = generateAuthToken(selectUser);
      String newRefreshToken = generateRefreshToken(selectUser);
      repos.rewriteRefreshTokenByRefreshTokenId(
          newRefreshToken, refreshTokenId);
      return Response.ok(
          jsonEncode(ApiResponse({
            'id': selectUser.id,
            'authToken': authToken,
            'refreshToken': refreshToken,
          }).toMap()),
          headers: defaultHeaders);
    });

    return router;
  }
}
