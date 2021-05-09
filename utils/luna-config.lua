local toml = require("utils.toml")

local cfg = {}

do
	local h = io.open("config.toml", "r")
	cfg = toml.parse(h:read("*a"))
	h:close()
end

do
	local h = io.open("engineinfo.toml", "r")
	_ENGINE = toml.parse(h:read("*a"))
	h:close()
end

return cfg