local toml = require("utils.toml")

local cfg = {}

do
	local h = io.open("config.toml", "r")
	cfg = toml.parse(h:read("*a"))
	h:close()
	cfg.boardlookup = {}
	for i=1, #cfg.luna.boards do
		cfg.boardlookup[cfg.luna.boards[i]] = true
	end
end

do
	local h = io.open("engineinfo.toml", "r")
	_ENGINE = toml.parse(h:read("*a"))
	h:close()
end

return cfg
