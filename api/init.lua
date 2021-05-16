local api = {flags={}}

local function loadsubapi(file)
	print(file)
	loadfile("api/"..file..".lua")(api)
end

loadsubapi("boards")
loadsubapi("thread")
loadsubapi("threads")
loadsubapi("files")
loadsubapi("admin")
loadsubapi("permissions")
return api
