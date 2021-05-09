-- random utils
local utils = {}
local config = require("utils.luna-config")
local blake2s = require("utils.blake2s")
local b64 = require("utils.ee5_base64")

function utils.safecall(func, ...)
	local args = {...}
	return xpcall(function()
		func(unpack(args))
	end, function(err)
		console.error("Safecall", err..":"..debug.traceback())
	end)
end

function utils.reqwrap(func)
	return function(...)
		local req = ...
		--req.inner = "Welcome to Lapis " .. require("lapis.version")
		req.boards = config.luna.boards
		req.boardinfo = config.boardinfo
		req.user = {theme = "classic"}
		return func(...)
	end
end

function utils.tripcode(input, salt)
	local hash = blake2s.hash(input..salt, 24, nil, "hex")
	return hash:sub(#hash-10)
end

function utils.randomstring(ent)
	if (type(ent) == "string") then
		return ent
	else
		return ent[math.random(1, #ent)]
	end
end

return utils
