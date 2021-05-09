-- Now, we do our stuff

local schema = require("lapis.db.schema")
local db = require("lapis.db")
local config = require("utils.luna-config")
local type = schema.types
local types = schema.types

--[[schema.drop_table("engine-info")
schema.drop_table("threads")
schema.drop_table("admins")
schema.drop_table("adminpriv")
schema.drop_table("posts")]]

-- info table
schema.create_table("engine-info", {
	{"engine", type.text},
	{"engine-version", type.text},
	{"schema-version", type.text}
})

schema.create_table("threads", {
	{"board", types.text},
	{"id", types.text},
	{"name", types.text},
	{"ctime", types.time},
	{"mtime", types.time},
	{"pin", types.integer},
	{"ip", types.text},
	{"flags", types.integer}
})

schema.create_table("posts", {
	{"board", types.text},
	{"thread", types.text},
	{"id", types.integer},
	{"time", types.time},
	{"trip", types.text},
	{"admin", "UUID"},
	{"content", types.text},
	{"picture", "text"},
	{"original_pic_name", "text"},
	{"ip", types.text}
})

schema.create_table("admins", {
	{"uuid", "UUID NOT NULL"},
	{"name", types.text},
	{"color", types.text},
	{"ranktext", types.text},
	{"flags", types.integer},
	{"passhash", types.text}
})

schema.create_table("adminpriv", {
	{"uuid", "UUID NOT NULL"},
	{"board", types.text},
	{"flags", types.integer}
})

db.insert("engine-info", {
	engine = "luna",
	["engine-version"] = _ENGINE.engine.engine_version,
	["schema-version"] = _ENGINE.engine.schema_version
})
