-- Hook subsystem
local lfs = require("lfs")
local utils = require("utils")

local loaded_hooks = {}

-- Load hooks
for dir in fs.dir("hooks") do
	if lfs.attribute("hooks/"..dir, "mode") == "directory" and dir:sub(1,1) ~= "." then
		loaded_hooks[dir] = {}
		for ent in fs.dir("hooks/"..dir) do
			if lfs.attribute("hooks/"..dir.."/"..ent, "mode") == "file" then
				utils.safecall(function()
					table.insert(loaded_hooks[dir], loadfile("hooks/"..dir.."/"..ent))
				end)
			end
		end
	end
end

local hooks = {}

function hooks.execute(name, ...)
	local args = {...}
	for _, hook in ipairs(loaded_hooks[name]) do
		local ret
		if utils.safecall(function()
			ret = {hook(unpack(args))}
		end) then
			if (#ret > 0) then
				return unpack(ret)
			end
		end
	end
end

return hooks