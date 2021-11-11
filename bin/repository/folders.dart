import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

class FoldersRepository {
  const FoldersRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;
}
