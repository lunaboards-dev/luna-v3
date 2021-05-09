local lfs = require("lfs")

local banners = {}

for ent in lfs.dir("static/banners") do
	if (lfs.attributes("static/banners/"..ent, "mode") == "directory" and ent:sub(1,1) ~= ".") then
		banners[ent] = {}
		--io.stdout:write("\n",ent,"\n")
		for banner in lfs.dir("static/banners/"..ent) do
			if (lfs.attributes("static/banners/"..ent.."/"..banner, "mode") == "file") then
				banners[ent][#banners[ent]+1] = "static/banners/"..ent.."/"..banner
				--io.stdout:write("\n","static/banners/"..ent.."/"..banner,"\n")
			end
		end
	end
end

--io.stdout:write("\n",ent,"\n")

local banner = {}

function banner.get(board)
	if (banners[board]) then
		local ban = banners[board][math.random(1, #banners[board])]
		--io.stdout:write("\n", tostring(ban), "\n")
		return ban
	end
end

return banner
