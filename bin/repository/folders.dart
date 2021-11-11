import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

class FoldersRepository {
  const FoldersRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;
}



// import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

// import '../structs/notification.dart';

// class NotificationListsRepository {
//   const NotificationListsRepository(this.__executor, this.__tableName);
//   final PostgreSqlExecutorPool __executor;
//   final String __tableName;

//   // Future<void> create(NotificationStruct list) async {
//   //   var rows = await __executor.query(
//   //       __tableName,
//   //       "INSERT INTO $__tableName"
//   //       "(owner_id, moderator_ids, subscribers_ids, title, description, public)"
//   //       "VALUES (@1, ARRAY${list.moderatorIds}::integer[], ARRAY${list.subscribersIds}::integer[], @4, @5, @6) RETURNING id",
//   //       {
//   //         '1': list.ownerId,
//   //         '4': list.title,
//   //         '5': list.description,
//   //         '6': list.public,
//   //       });
//   //   list.id = rows[0][0];
//   // }

//   // Future<List<NotificationStruct>> getAll(int userId) async {
//   //   var rows = await __executor.query(
//   //       __tableName,
//   //       'SELECT * FROM $__tableName WHERE owner_id = @1 OR @1 = ANY(subscribers_ids) OR @1 = ANY(moderator_ids)',
//   //       {'1': userId});
//   //   List<NotificationStruct> lists = [];
//   //   for (var parseList in rows) {
//   //     if (parseList.isEmpty) {
//   //       continue;
//   //     }
//   //     lists.add(NotificationStruct(
//   //       id: parseList[0],
//   //       ownerId: parseList[1],
//   //       moderatorIds: parseList[2],
//   //       subscribersIds: parseList[3],
//   //       title: parseList[4],
//   //       description: parseList[5],
//   //       public: parseList[6],
//   //     ));
//   //   }
//   //   return lists;
//   // }

//   // Future<void> delete(int listId, int userId) async {
//   //   await __executor.query(
//   //       __tableName,
//   //       'DELETE FROM $__tableName WHERE id = @1 AND owner_id = @2',
//   //       {'1': listId, '2': userId});
//   // }

//   // Future<NotificationStruct> getById(int listId, int userId) async {
//   //   var data = await __executor.query(
//   //       __tableName,
//   //       'SELECT *  FROM $__tableName'
//   //       ' WHERE id = @1 AND owner_id = @2 '
//   //       'OR @2 = ANY(subscribers_ids) OR @2 = ANY(moderator_ids)',
//   //       {'1': listId, '2': userId});
//   //   return NotificationStruct(
//   //     id: data[0][0],
//   //     ownerId: data[0][1],
//   //     moderatorIds: data[0][2],
//   //     subscribersIds: data[0][3],
//   //     title: data[0][4],
//   //     description: data[0][5],
//   //     public: data[0][6],
//   //   );
//   // }

//   // Future<void> edit(NotificationStruct list) async {
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET title = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.title,
//   //   });
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET description = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.description,
//   //   });
//   //   print('2');
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET public = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.public,
//   //   });
//   // }
// }