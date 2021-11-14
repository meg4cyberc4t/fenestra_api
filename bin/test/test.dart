// import 'dart:convert';

// import 'package:http/http.dart' as http;
// // import '../main.dart' as server;
// import 'package:test/test.dart';

// void main() async {
//   // await server.main();

//   group('users', () {
//     test('/ #PATCH', () async {
//       http.Response data = await http.patch(
//         Uri.parse('http://localhost:8080/user/'),
//         headers: {
//           "Authorization": authToken,
//           "Content-Type": 'application/json',
//         },
//         body: jsonEncode({
//           "first_name": defaultFirstName + '1',
//           "last_name": defaultLastName + '1',
//           "login": defaultLogin + '1',
//           "password": defaultPassword + '1',
//           "color": defaultColor + 1,
//         }),
//       );
//       var input = jsonDecode(utf8.decode(data.bodyBytes));
//       expect(input['id'] != null, true);
//       expect(input['first_name'], defaultFirstName + '1');
//       expect(input['last_name'], defaultLastName + '1');
//       expect(input['login'], defaultLogin + '1');
//       expect(input['color'], defaultColor + 1);
//       expect(data.statusCode, 200);

//       data = await http.get(
//         Uri.parse('http://localhost:8080/user/'),
//         headers: {"Authorization": authToken},
//       );
//       input = jsonDecode(utf8.decode(data.bodyBytes));
//       expect(input['id'] != null, true);
//       expect(input['first_name'], defaultFirstName + '1');
//       expect(input['last_name'], defaultLastName + '1');
//       expect(input['login'], defaultLogin + '1');
//       expect(input['color'], defaultColor + 1);
//       expect(data.statusCode, 200);
//       await http.patch(
//         Uri.parse('http://localhost:8080/user/'),
//         headers: {
//           "Authorization": authToken,
//           "Content-Type": 'application/json',
//         },
//         body: jsonEncode({
//           "first_name": defaultFirstName,
//           "last_name": defaultLastName,
//           "login": defaultLogin,
//           "password": defaultPassword,
//           "color": defaultColor,
//         }),
//       );
//       data = await http.post(
//         Uri.parse('http://localhost:8080/auth/sign-in'),
//         headers: {"Content-Type": 'application/json'},
//         body: jsonEncode({
//           "login": defaultLogin,
//           "password": defaultPassword,
//         }),
//       );
//       expect(data.statusCode, 200);
//       Map variables = jsonDecode(data.body);
//       defaultId = variables['id'];
//       authToken = variables['auth_token'];
//       refreshToken = variables['refresh_token'];
//     });

//     group('/default/bond #GET', () {
//       test('Subscribe', () async {
//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId2/bond'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 201);

//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId2'),
//           headers: {"Authorization": authToken},
//         );
//         input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscribers'].contains(defaultId), true);
//         data =
//             await http.get(Uri.parse('http://localhost:8080/user/'), headers: {
//           "Authorization": authToken,
//         });
//         input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscriptions'].contains(defaultId2), true);
//       });

//       test('Delete subscribe', () async {
//         http.Response data = await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId2/bond'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 201);
//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId2'),
//           headers: {"Authorization": authToken},
//         );
//         var input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscriptions'].contains(defaultId2), false);
//         expect(input['subscribers'].contains(defaultId2), false);
//         expect(input['colleagues'].contains(defaultId2), false);
//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/'),
//           headers: {"Authorization": authToken},
//         );
//         input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscriptions'].contains(defaultId), false);
//         expect(input['subscribers'].contains(defaultId), false);
//         expect(input['colleagues'].contains(defaultId), false);
//       });

//       test('Add bond', () async {
//         await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId2/bond'),
//           headers: {"Authorization": authToken},
//         );
//         await http.get(
//           Uri.parse('http://localhost:8080/user/$defaultId/bond'),
//           headers: {"Authorization": defaultAuthToken2},
//         );

//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/'),
//           headers: {"Authorization": authToken},
//         );
//         input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscriptions'].contains(defaultId2), false);
//         expect(input['subscribers'].contains(defaultId2), false);
//         expect(input['colleagues'].contains(defaultId2), true);

//         data = await http.get(
//           Uri.parse('http://localhost:8080/user/'),
//           headers: {"Authorization": defaultAuthToken2},
//         );
//         input = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(input['subscriptions'].contains(defaultId), false);
//         expect(input['subscribers'].contains(defaultId), false);
//         expect(input['colleagues'].contains(defaultId), true);
//       });
//     });
//   });
//   group('Notify', () {
//     group('folders', () {
//       test('/ #GET', () async {
//         data = await http.get(
//           Uri.parse('http://localhost:8080/notify/folder/'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 200);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)) is List, true);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)).isEmpty, true);
//       });

//       late int folderid;
//       test('/ #POST', () async {
//         data = await http.post(
//           Uri.parse('http://localhost:8080/notify/folder/'),
//           headers: {"Authorization": authToken},
//           body: jsonEncode({
//             "title": "Тестовое название",
//             "description": "Тестовое описание",
//             "priority": 0,
//           }),
//         );
//         expect(data.statusCode, 200);
//         expect(jsonDecode(utf8.decode(data.bodyBytes))['id'] is int, true);
//         data = await http.get(
//           Uri.parse('http://localhost:8080/notify/folder/'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 200);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)) is List, true);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)).isEmpty, false);
//         Map selectFolder = jsonDecode(utf8.decode(data.bodyBytes))[0];
//         expect(selectFolder['id'] != null, true);
//         expect(selectFolder['owner'] != null, true);
//         expect(selectFolder['title'] != null, true);
//         expect(selectFolder['description'] != null, true);
//         expect(selectFolder['participants'] != null, true);
//         expect(selectFolder['priority'] != null, true);
//         folderid = selectFolder['id'];
//       });

//       test('/<id> #GET', () async {
//         data = await http.get(
//           Uri.parse('http://localhost:8080/notify/folder/$folderid'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 200);
//         Map selectFolder = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(selectFolder['id'] != null, true);
//         expect(selectFolder['owner'] != null, true);
//         expect(selectFolder['title'] != null, true);
//         expect(selectFolder['description'] != null, true);
//         expect(selectFolder['participants'] != null, true);
//         expect(selectFolder['priority'] != null, true);
//       });

//       test('/<id> #DELETE', () async {
//         data = await http.delete(
//           Uri.parse('http://localhost:8080/notify/folder/$folderid'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 201);

//         data = await http.get(
//           Uri.parse('http://localhost:8080/notify/folder/'),
//           headers: {"Authorization": authToken},
//         );
//         expect(data.statusCode, 200);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)) is List, true);
//         expect(jsonDecode(utf8.decode(data.bodyBytes)).isEmpty, true);
//       });
//       test('/<id> #PATCH', () async {
//         data = await http.post(
//           Uri.parse('http://localhost:8080/notify/folder/'),
//           headers: {"Authorization": authToken},
//           body: jsonEncode({
//             "title": "test",
//             "description": "dtest",
//             "priority": 0,
//           }),
//         );
//         int id = jsonDecode(utf8.decode(data.bodyBytes))['id'];
//         data = await http.patch(
//             Uri.parse('http://localhost:8080/notify/folder/$id'),
//             headers: {"Authorization": authToken},
//             body: jsonEncode({
//               "title": "test1",
//               "description": "dtest1",
//               "priority": 1,
//             }));
//         expect(data.statusCode, 200);

//         data = await http.get(
//           Uri.parse('http://localhost:8080/notify/folder/$id'),
//           headers: {"Authorization": authToken},
//         );
//         Map selectFolder = jsonDecode(utf8.decode(data.bodyBytes));
//         expect(selectFolder['id'] != null, true);
//         expect(selectFolder['owner'] != null, true);
//         expect(selectFolder['title'] != null, true);
//         expect(selectFolder['description'] != null, true);
//         expect(selectFolder['participants'] != null, true);
//         expect(selectFolder['priority'] != null, true);
//         expect(selectFolder['title'], 'test1');
//         expect(selectFolder['description'], 'dtest1');
//         expect(selectFolder['priority'], 1);
//       });
//     });
//   });
// }
