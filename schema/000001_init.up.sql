CREATE TABLE "users" (
	"id" uuid NOT NULL PRIMARY KEY,
	"first_name" varchar NOT NULL,
	"last_name" varchar NOT NULL,
	"login" varchar NOT NULL UNIQUE,
	"password_hash" varchar NOT NULL,
	"colleagues" integer[] NOT NULL DEFAULT array[]::integer[],
	"subscribers" integer[] NOT NULL DEFAULT array[]::integer[],
	"photo" varchar,
	"photo200" varchar
);

CREATE TABLE "notifications" (
	"id" uuid NOT NULL UNIQUE PRIMARY KEY,
	"title" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	"owner" uuid NOT NULL,
	"deadline" TIMESTAMP WITH TIME ZONE NOT NULL,
	"repeat" smallint
);

CREATE TABLE "folders" (
	"id" uuid NOT NULL UNIQUE PRIMARY KEY,
	"owner" uuid NOT NULL,
	"participants" uuid[] NOT NULL DEFAULT array[]::uuid[],
	"title" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	"priority" smallint DEFAULT 0
);

CREATE TABLE "refresh_tokens" (
	"id" uuid NOT NULL PRIMARY KEY,
	"owner" uuid NOT NULL,
	"token" varchar(255) NOT NULL
);

ALTER TABLE "notifications" ADD CONSTRAINT "notifications_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "folders" ADD CONSTRAINT "folders_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");