import 'dart:convert';

import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../structs/user.dart';
import 'package:crypto/crypto.dart';

class UserHandlers {
  const UserHandlers(this.repos);
  final Repository repos;

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      return Response.ok(jsonEncode(selectUser.toMap()));
    });

    router.get('/<id>', (Request request, String id) async {
      late UserStruct selectUser;
      try {
        selectUser = await repos.users.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(selectUser.toMap()));
    });

    router.patch('/', (Request request) async {
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      dynamic input = jsonDecode(await request.readAsString());
      if (input['login'] != null) {
        selectUser.login = input['login'];
      }
      if (input['first_name'] != null) {
        selectUser.firstName = input['first_name'];
      }
      if (input['last_name'] != null) {
        selectUser.lastName = input['last_name'];
      }
      if (input['password'] != null) {
        selectUser.passwordHash =
            md5.convert(utf8.encode(input['password'])).toString();
        repos.refreshTokens.logoutAll(selectUser.id!);
      }
      if (input['color'] != null) {
        selectUser.color = input['color'];
      }
      repos.users.edit(selectUser);
      return Response.ok(jsonEncode(selectUser.toMap()));
    });

    router.get('/<id>/relation', (Request request, String id) async {
      int subjectId = int.parse(id);
      UserStruct subjUser = await repos.users.getFromId(subjectId);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);

      if (await repos.users.isCollegues(selectUser, subjUser)) {
        await repos.users.deleteCollegues(selectUser, subjUser);
        await repos.users.setSubscribe(subjUser, selectUser);
      } else if (await repos.users.isSubscribe(subjUser, selectUser)) {
        await repos.users.deleteSubscribe(subjUser, selectUser);
        await repos.users.setCollegues(selectUser, subjUser);
      } else if (await repos.users.isSubscribe(selectUser, subjUser)) {
        await repos.users.deleteSubscribe(selectUser, subjUser);
      } else {
        await repos.users.setSubscribe(selectUser, subjUser);
      }
      return Response(201);
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(''),
    );

    return router;
  }
}
