import '../structs/user.dart';

import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

class UsersRepository {
  const UsersRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;

  Future<void> add(User user) async {
    var rows = await __executor.query(
        __tableName,
        'INSERT INTO $__tableName (name, login, password_hash) VALUES (@1, @2, @3) RETURNING id',
        {
          '1': user.name,
          '2': user.login,
          '3': user.passwordHash,
        });
    user.id = rows[0][0];
  }

  Future<bool> checkUniqueLogin(String login) async {
    var rows = await __executor.query(__tableName,
        'SELECT * FROM $__tableName WHERE login = @1', {'1': login});
    return rows.isEmpty;
  }

  Future<int> getIdByLogin(String login) async {
    var rows = await __executor.query(__tableName,
        'SELECT id FROM $__tableName WHERE login = @1', {'1': login});
    return rows[0][0];
  }

  Future<int> getLoginById(int id) async {
    var rows = await __executor.query(
        __tableName, 'SELECT login FROM $__tableName WHERE id = @1', {'1': id});
    return rows[0][0];
  }

  Future<User> getFromId(int id) async {
    var rows = await __executor.query(
        __tableName, 'SELECT * FROM $__tableName WHERE id = @1', {'1': id});
    return User(
      id: rows[0][0],
      name: rows[0][1],
      login: rows[0][2],
      passwordHash: rows[0][3],
    );
  }

  Future<User> getFromLogin(String login) async {
    return await getFromId(await getIdByLogin(login));
  }
}
