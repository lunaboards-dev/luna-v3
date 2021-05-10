local api = {}

local function loadsubapi(file)
	loadfile("api/"..file..".lua")(api)
end

loadsubapi("boards")
loadsubapi("thread")
loadsubapi("threads")
loadsubapi("files")
return api
