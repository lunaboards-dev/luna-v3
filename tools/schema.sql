-- Schema version lunav3-0-0-1620622800
-- Luna version lunav3-0-0

DROP TABLE IF EXISTS "engine-info";
DROP TABLE IF EXISTS threads;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS adminpriv;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS filereftrack;

CREATE TABLE "engine-info" (
	engine text NOT NULL,
	"engine-version" text NOT NULL,
	"schema-version" text NOT NULL
);

INSERT INTO "engine-info"(engine, "engine-version", "schema-version") VALUES ('luna', 'lunav3-0-0', 'lunav3-0-0-1620622800');

CREATE TABLE threads (
	board text NOT NULL,
	id text NOT NULL,
	name text NOT NULL,
	created_at timestamp without time zone NOT NULL,
	updated_at timestamp without time zone NOT NULL,
	pin integer NOT NULL DEFAULT 0,
	ip text NOT NULL,
	count integer NOT NULL DEFAULT 0,
	flags integer NOT NULL DEFAULT 0
);

CREATE TABLE posts (
	board text NOT NULL,
	thread text NOT NULL,
	id integer NOT NULL,
	created_at timestamp without time zone NOT NULL,
	updated_at timestamp without time zone NOT NULL,
	trip text NOT NULL,
	admin UUID,
	content text NOT NULL,
	picture text,
	original_name text,
	ip text NOT NULL
);

CREATE TABLE admins (
	uuid UUID NOT NULL,
	name text NOT NULL,
	color text NOT NULL,
	ranktext text NOT NULL,
	flags integer NOT NULL DEFAULT 0,
	passhash text NOT NULL,
	token text NOT NULL,
	old_token text NOT NULL
);

CREATE TABLE adminpriv (
	uuid UUID NOT NULL,
	board text NOT NULL,
	flags integer NOT NULL
);

CREATE TABLE filereftrack (
	filename text NOT NULL,
	thumbnail text NOT NULL,
	blake2 text NOT NULL,
	refcount integer NOT NULL DEFAULT 1,
	uuid UUID NOT NULL,
	ext text NOT NULL,
	mime text
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO luna;
