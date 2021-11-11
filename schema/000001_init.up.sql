CREATE TABLE "users" (
	"id" integer UNIQUE PRIMARY KEY,
	"first_name" varchar NOT NULL,
	"last_name" varchar NOT NULL,
	"login" varchar NOT NULL UNIQUE,
	"password_hash" varchar NOT NULL,
	"colleagues" integer[] DEFAULT ARRAY[]::integer[],
	"subscribers" integer[] DEFAULT ARRAY[]::integer[],
	"photo" varchar,
	"photo200" varchar
);

CREATE TABLE "notifications" (
	"id" integer UNIQUE PRIMARY KEY,
	"title" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	"owner" integer NOT NULL,
	"deadline" TIMESTAMP WITH TIME ZONE NOT NULL,
	"repeat" smallint
);

CREATE TABLE "folders" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"participants" integer[] DEFAULT ARRAY[]::integer[], 
	"title" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	"priority" smallint DEFAULT 0
);

CREATE TABLE "refresh_tokens" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"token" varchar NOT NULL
);

ALTER TABLE "notifications" ADD CONSTRAINT "notifications_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "folders" ADD CONSTRAINT "folders_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");