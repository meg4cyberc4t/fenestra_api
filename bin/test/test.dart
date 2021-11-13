import 'dart:convert';

import 'package:http/http.dart' as http;
import '../main.dart' as server;
import 'package:test/test.dart';

void main() async {
  //init server
  await server.main();

  //testing server
  late String authToken;
  late String refreshToken;
  group('Authorization', () {
    test('Sign up', () async {
      http.Response data = await http.post(
        Uri.parse('http://localhost:8080/auth/sign-up'),
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({
          "first_name": "Игорь",
          "last_name": "Молчанов",
          "login": 'login',
          "password": 'password',
          "color": 0
        }),
      );
      if (data.statusCode != 422) {
        expect(data.statusCode, 200);
        Map variables = jsonDecode(data.body);
        authToken = variables['auth_token'];
        refreshToken = variables['refresh_token'];
      }
    });
    test('Sign in', () async {
      http.Response data = await http.post(
        Uri.parse('http://localhost:8080/auth/sign-in'),
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({
          "login": 'login',
          "password": 'password',
        }),
      );
      expect(data.statusCode, 200);
      Map variables = jsonDecode(data.body);
      authToken = variables['auth_token'];
      refreshToken = variables['refresh_token'];
    });
    test('Reload token', () async {
      http.Response data = await http.post(
        Uri.parse('http://localhost:8080/auth/reload-token'),
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({
          "refresh_token": refreshToken,
        }),
      );
      refreshToken = jsonDecode(data.body)['refresh_token'];
      expect(data.statusCode, 200);
    });

    test('Not found', () async {
      http.Response data = await http.post(
        Uri.parse('http://localhost:8080/auth/notfound'),
        headers: {"Content-Type": 'application/json'},
      );
      expect(data.statusCode, 404);
      expect(data.body, '');
    });
  });

  //  router.get('/', (Request request) async {
  //     UserStruct selectUser =
  //         await repos.users.getFromId(request.context['id'] as int);
  //     return Response.ok(jsonEncode(selectUser.toMap()));
  //   });

  //   router.get('/<id>', (Request request, String id) async {
  //     late UserStruct selectUser;
  //     try {
  //       selectUser = await repos.users.getFromId(int.parse(id));
  //     } catch (e) {
  //       print(e);
  //       return Response(404);
  //     }
  //     return Response.ok(jsonEncode(selectUser.toMap()));
  //   });

  //   router.patch('/', (Request request) async {
  //     UserStruct selectUser =
  //         await repos.users.getFromId(request.context['id'] as int);
  //     dynamic input = jsonDecode(await request.readAsString());
  //     if (input['login'] != null) {
  //       selectUser.login = input['login'];
  //     }
  //     if (input['first_name'] != null) {
  //       selectUser.firstName = input['first_name'];
  //     }
  //     if (input['last_name'] != null) {
  //       selectUser.lastName = input['last_name'];
  //     }
  //     if (input['password'] != null) {
  //       selectUser.passwordHash =
  //           md5.convert(utf8.encode(input['password'])).toString();
  //       repos.refreshTokens.logoutAll(selectUser.id!);
  //     }
  //     if (input['color'] != null) {
  //       selectUser.color = input['color'];
  //     }
  //     repos.users.edit(selectUser);
  //     return Response.ok(jsonEncode(selectUser.toMap()));
  //   });

  //   router.get('/<id>/bond', (Request request, String id) async {
  //     int subjectId = int.parse(id);
  //     UserStruct subjUser = await repos.users.getFromId(subjectId);
  //     UserStruct selectUser =
  //         await repos.users.getFromId(request.context['id'] as int);
  //     if (!selectUser.colleagues.contains(subjUser.id) &&
  //         subjUser.subscribers.contains(selectUser.id) &&
  //         selectUser.subscribers.contains(subjUser.id)) {
  //       await repos.users.addSubscribers(selectUser, subjUser);
  //       // Если у владельца и обьекта нет связи
  //     } else if (selectUser.subscribers.contains(subjUser.id)) {
  //       await repos.users.deleteSubscribers(selectUser, subjUser);
  //       // Если владелец подписан на обьект
  //     } else if (subjUser.subscribers.contains(selectUser.id)) {
  //       await repos.users.deleteSubscribers(subjUser, selectUser);
  //       await repos.users.addBond(subjUser, selectUser);
  //       // Если обьект подписан на владелец
  //     } else {
  //       await repos.users.deleteBond(subjUser, selectUser);
  //       await repos.users.addSubscribers(subjUser, selectUser);
  //       // Если владелец и субьект коллеги
  //     }
  //     return Response(201);
}
