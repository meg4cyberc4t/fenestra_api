import 'dart:math';

import 'package:postgres/postgres.dart';
import '../structs/refresh_token.dart';

class RefreshTokensRepository {
  const RefreshTokensRepository(this.__executor, this.__tableName);
  final PostgreSQLConnection __executor;
  final String __tableName;

  Future<int> _generateId() async {
    int id = Random().nextInt(2147483647);
    while (!await _isUniqueId(id)) {
      id = Random().nextInt(2147483647);
    }
    return id;
  }

  Future<bool> _isUniqueId(int id) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE id = @1",
        substitutionValues: {'1': id});
    return data.isEmpty ? true : data[0].isEmpty;
  }

  Future<void> write(RefreshTokenStruct token) async {
    token.id = await _generateId();
    await __executor.query(
        "INSERT INTO $__tableName (id, owner, token) VALUES (@1, @2, @3)",
        substitutionValues: {
          '1': token.id,
          '2': token.owner,
          '3': token.token,
        });
  }

  Future<RefreshTokenStruct> get(String refreshToken) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE token = @1',
        substitutionValues: {'1': refreshToken});
    return RefreshTokenStruct(
        id: rows[0][0], owner: rows[0][1], token: rows[0][2]);
  }

  Future<void> rewrite(RefreshTokenStruct refreshToken) async {
    await __executor.query(
        'UPDATE $__tableName SET token = @1 WHERE id = @2 AND owner = @3',
        substitutionValues: {
          '1': refreshToken.token,
          '2': refreshToken.id,
          '3': refreshToken.owner,
        });
  }
}
