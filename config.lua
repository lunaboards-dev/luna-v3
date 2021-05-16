-- config.lua
local config = require("lapis.config")
local cfg = require("utils.luna-config")

config({"development", "production"}, {
	port = 8080,
	postgres = {
		host = cfg.database.host,
		user = cfg.database.user,
		password = cfg.database.password,
		database = cfg.database.database,
		port = cfg.database.port
	},
	systemd = {
		user = "luna"
	}
	secret = cfg.luna.secret,
	session_name = "luna"
})

config("production", {
	code_cache = "on"
})

--[[
	SELECT EXISTS (
   SELECT FROM information_schema.tables
   WHERE  table_schema = 'schema_name'
   AND    table_name   = 'table_name'
   );
]]

--[[local db = require("lapis.db")
if (not db.query("select exists (select from information_schema.tables where table_schema = ? and table_name = ?)", cfg.database.database, "engine-info").exists) then
	coroutine.yield()
	dofile("dbsetup")
end]]
