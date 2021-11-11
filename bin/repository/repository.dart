import 'dart:math';

import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

import 'folders.dart';
import 'notifications.dart';
import 'refresh_tokens.dart';
import 'users.dart';

class Repository {
  Repository(this.executor) {
    users = UsersRepository(executor, 'users');
    notifications = NotificationsRepository(executor, 'notifications');
    folders = FoldersRepository(executor, 'folders');
    refreshTokens = RefreshTokensRepository(executor, 'refresh_tokens');
  }
  final PostgreSqlExecutorPool executor;
  late UsersRepository users;
  late NotificationsRepository notifications;
  late FoldersRepository folders;
  late RefreshTokensRepository refreshTokens;
//   CREATE TABLE "users" (
// 	"id" uuid NOT NULL PRIMARY KEY,
// 	"first_name" varchar NOT NULL,
// 	"last_name" varchar NOT NULL,
// 	"login" varchar NOT NULL UNIQUE,
// 	"password_hash" varchar NOT NULL,
// 	"colleagues" integer[] NOT NULL DEFAULT array[]::integer[],
// 	"subscribers" integer[] NOT NULL DEFAULT array[]::integer[],
// 	"photo" varchar,
// 	"photo200" varchar
// );

// CREATE TABLE "notifications" (
// 	"id" uuid NOT NULL UNIQUE PRIMARY KEY,
// 	"title" varchar(255) NOT NULL,
// 	"description" varchar(255) NOT NULL,
// 	"owner" uuid NOT NULL,
// 	"deadline" TIMESTAMP WITH TIME ZONE NOT NULL,
// 	"repeat" smallint
// );

// CREATE TABLE "folders" (
// 	"id" uuid NOT NULL UNIQUE PRIMARY KEY,
// 	"owner" uuid NOT NULL,
// 	"participants" uuid[] NOT NULL DEFAULT array[]::uuid[],
// 	"title" varchar(255) NOT NULL,
// 	"description" varchar(255) NOT NULL,
// 	"priority" smallint DEFAULT 0
// );

// CREATE TABLE "refresh_tokens" (
// 	"id" uuid NOT NULL PRIMARY KEY,
// 	"owner" uuid NOT NULL,
// 	"token" varchar(255) NOT NULL
// );

}
