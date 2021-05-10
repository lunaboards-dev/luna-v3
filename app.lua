local lapis = require("lapis")
local app = lapis.Application()
local config = require("utils.luna-config")
local utils = require("utils")
app:enable("etlua")
api = require("api.init")
app.layout = require("views.desktop.main")
math.randomseed(os.time())

--[[local db = require("lapis.db")
app:before_filter(function()
	if (not db.query("select exists (select from information_schema.tables where table_schema = ? and table_name = ?)", config.database.database, "engine-info").exists) then
		dofile("dbsetup.lua")
	end
end)]]

--[[app:get("/", function(req)
	req.inner = "Welcome to Lapis " .. require("lapis.version")
	req.boards = config.luna.boards
	req.boardinfo = config.boardinfo
	req.user = {theme = "classic"}
	return {render = "desktop.blank", boards = config.luna.boards, boardinfo = config.boardinfo, user = {}}
end)]]

app:get("/", utils.reqwrap(require("pages.main")))
app:get("/:board", utils.reqwrap(require("pages.threads")))
app:match("/:board/new", utils.reqwrap(require("pages.newthread")))
app:match("/:board/:thread", utils.reqwrap(require("pages.posts")))

app:get("/themes/:theme", require("pages.themes"))

return app
