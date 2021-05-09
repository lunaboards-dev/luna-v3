-- random utils
local utils = {}
local config = require("utils.luna-config")

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

return utils