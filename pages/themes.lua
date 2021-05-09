local themes = {}

local lfs = require("lfs")
local config = require("utils.luna-config")

for ent in lfs.dir("styles") do
	if (lfs.attributes("styles/"..ent, "mode") == "file") then
		local h = io.open("styles/"..ent, "r")
		local data = h:read("*a")
		local style = data:gsub("%$[0-9a-f]", function(match)
			return config.colors.clist[tonumber(match:sub(2,2), 16)+1]
		end)
		themes[ent] = style
		--print(style)
	end
end

return function(self)
	return { layout = false, themes[self.params.theme], content_type = "text/css"}
end