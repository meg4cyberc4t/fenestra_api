import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';
import 'package:uuid/uuid.dart';

import '../structs/refresh_token.dart';

class RefreshTokensRepository {
  const RefreshTokensRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;

  Future<void> write(RefreshTokenStruct token) async {
    token.id = Uuid().v4();
    while (!await _isUniqueId(token.id!)) {
      token.id = Uuid().v4();
    }
    await __executor.query(__tableName,
        "INSERT INTO $__tableName (id, owner, token) VALUES (@1, @2, @3)", {
      '1': token.id,
      '2': token.owner,
      '3': token.token,
    });
  }

  Future<bool> _isUniqueId(String id) async {
    var data = await __executor.query(
        __tableName, "SELECT * FROM  $__tableName WHERE id = @1", {'1': id});
    return data.isEmpty ? true : data[0].isEmpty;

    // Future<RefreshTokenStruct> get(String refreshToken) async {
    //   var rows = await __executor.query(__tableName,
    //       'SELECT * FROM $__tableName WHERE token = @1', {'1': refreshToken});
    //   return RefreshTokenStruct(id: rows[0][0], ownerId: rows[0][1], token: rows[0][2]);
    // }

    // Future<void> rewrite(int refreshTokenId, String newRefreshToken) async {
    //   await __executor.query(
    //       __tableName,
    //       'UPDATE $__tableName SET token = @1 WHERE id = @2',
    //       {'1': newRefreshToken, '2': refreshTokenId});
    // }
  }
}
