CREATE TABLE "users" (
	"id" integer UNIQUE PRIMARY KEY,
	"first_name" varchar NOT NULL,
	"last_name" varchar NOT NULL,
	"login" varchar NOT NULL UNIQUE,
	"password_hash" varchar NOT NULL,
	"colleagues" integer[] DEFAULT ARRAY[]::integer[],
	"subscribers" integer[] DEFAULT ARRAY[]::integer[],
	"subscriptions" integer[] DEFAULT ARRAY[]::integer[],
	"color" integer NOT NULL CHECK(color >=0 AND color <= 16777215)
);

CREATE TABLE "refresh_tokens" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"token" varchar NOT NULL
);

ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");


CREATE TABLE "notify_folders" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" varchar(255),
	"participants" integer[] DEFAULT ARRAY[]::integer[], 
	"priority" smallint DEFAULT 0
);

ALTER TABLE "notify_folders" ADD CONSTRAINT "notify_folders_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");

CREATE TABLE "notify_notifications" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" varchar(255),
	"deadline" bigint,
	"repeat" smallint,
	"folder" integer,
	"invited" integer[] DEFAULT ARRAY[]::integer[]
);

ALTER TABLE "notify_notifications" ADD CONSTRAINT "notify_notifications_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "notify_notifications" ADD CONSTRAINT "notify_notifications_fk1" FOREIGN KEY ("folder") REFERENCES "notify_folders"("id");
