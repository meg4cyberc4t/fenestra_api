import 'package:postgres/postgres.dart';

class NotificationsRepository {
  const NotificationsRepository(this.__executor, this.__tableName);
  final PostgreSQLConnection __executor;
  final String __tableName;
}
