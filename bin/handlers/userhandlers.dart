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
      return Response.ok(jsonEncode({
        'id': selectUser.id,
        'first_name': selectUser.firstName,
        'last_name': selectUser.lastName,
        'login': selectUser.login,
        'colleagues': selectUser.colleagues,
        'subscribers': selectUser.subscribers,
        'photo': selectUser.photo,
        'photo200': selectUser.photo200,
      }));
    });

    router.get('/<id>', (Request request, String id) async {
      UserStruct selectUser = await repos.users.getFromId(int.parse(id));
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
      repos.users.edit(selectUser);
      return Response.ok(jsonEncode(selectUser.toMap()));
    });

    // router.post('/', (Request request) async {
    //   late NotificationStruct list;
    //   dynamic input = jsonDecode(await request.readAsString());
    //   list = NotificationStruct.fromParametersWithJson(
    //     json: input,
    //     id: -1,
    //     ownerId: request.context['id'] as int,
    //     moderatorIds: <int>[],
    //     subscribersIds: <int>[],
    //   );
    //   await repos.lists.create(list);
    //   return Response(201);
    // });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('Resource not found'),
    );

    return router;
  }
}
