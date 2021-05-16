-- random utils
local utils = {}
local config = require("utils.luna-config")
local blake2s = require("utils.blake2b")
local b64 = require("utils.ee5_base64")
local bcrypt = require("bcrypt")

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

function utils.uuid()
	local h = io.popen("uuidgen", "r")
	local d = h:read("*a"):gsub("%s", "")
	h:close()
	return d
end

local scale = {"bytes", "KiB", "MiB", "GiB"}
function utils.machine_to_human(mach)
	mach = mach or 0
	local i = 1
	while mach >= 1024 do
		mach = mach / 1024
		i = i + 1
	end
	return string.format("%.1f %s", mach, scale[i])
end

function utils.handlemessage(req)
	req.message = req.session.message
	req.session.message = nil
end

return utils
