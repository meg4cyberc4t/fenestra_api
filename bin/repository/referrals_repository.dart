import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

class ReferralsForListsRepository {
  const ReferralsForListsRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;

  // TODO: Delete when the first method appears
  void plug() => print('$__executor $__tableName');
}
