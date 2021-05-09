local api = {}

local function loadsubapi(file)
	loadfile("api/"..file..".lua")(api)
end

loadsubapi("boards")
return api