local lapis = require("lapis")
local app = lapis.Application()
local config = require("utils.luna-config")
local utils = require("utils")
app:enable("etlua")
app.layout = require("views.desktop.main")

--[[app:get("/", function(req)
	req.inner = "Welcome to Lapis " .. require("lapis.version")
	req.boards = config.luna.boards
	req.boardinfo = config.boardinfo
	req.user = {theme = "classic"}
	return {render = "desktop.blank", boards = config.luna.boards, boardinfo = config.boardinfo, user = {}}
end)]]

app:get("/", utils.reqwrap(require("pages.main")))
app:get("/:board", utils.reqwrap(require("pages.threads")))

app:get("/themes/:theme", require("pages.themes"))

return app
