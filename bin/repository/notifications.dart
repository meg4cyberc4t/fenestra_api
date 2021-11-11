import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

class NotificationsRepository {
  const NotificationsRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;
}
