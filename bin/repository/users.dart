import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';
import 'package:uuid/uuid.dart';

import '../structs/user.dart';

class UsersRepository {
  const UsersRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;

  Future<void> add(UserStruct user) async {
    user.id = Uuid().v4();
    while (!await _isUniqueId(user.id!)) {
      user.id = Uuid().v4();
    }
    var rows = await __executor.query(
        __tableName,
        "INSERT INTO $__tableName (id, first_name, last_name, login, password_hash)"
        " VALUES (@1, @2, @3, @4, @5) RETURNING id",
        {
          '1': user.id,
          '2': user.firstName,
          '3': user.lastName,
          '4': user.login,
          '5': user.passwordHash,
        });
    user.id = rows[0][0];
  }

  Future<bool> _isUniqueId(String id) async {
    var data = await __executor.query(
        __tableName, "SELECT * FROM  $__tableName WHERE id = @1", {'1': id});
    return data.isEmpty ? true : data[0].isEmpty;
  }
  // Future<bool> checkUniqueLogin(String login) async {
  //   var rows = await __executor.query(__tableName,
  //       'SELECT * FROM $__tableName WHERE login = @1', {'1': login});
  //   return rows.isEmpty;
  // }

  // Future<int> getIdByLogin(String login) async {
  //   var rows = await __executor.query(__tableName,
  //       'SELECT id FROM $__tableName WHERE login = @1', {'1': login});
  //   return rows[0][0];
  // }

  // Future<int> getLoginById(int id) async {
  //   var rows = await __executor.query(
  //       __tableName, 'SELECT login FROM $__tableName WHERE id = @1', {'1': id});
  //   return rows[0][0];
  // }

  // Future<UserStruct> getFromId(int id) async {
  //   var rows = await __executor.query(
  //       __tableName, 'SELECT * FROM $__tableName WHERE id = @1', {'1': id});
  //   return UserStruct(
  //     id: rows[0][0],
  //     name: rows[0][1],
  //     login: rows[0][2],
  //     passwordHash: rows[0][3],
  //   );
  // }

  // Future<UserStruct> getFromLogin(String login) async {
  //   return await getFromId(await getIdByLogin(login));
  // }
}
