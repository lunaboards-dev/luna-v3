local lapis = require("lapis")
local app = lapis.Application()
local config = require("utils.luna-config")
local utils = require("utils")
local admins = require("utils.admins")
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

app:before_filter(utils.handlemessage)
app:before_filter(admins.authfilter)
app:before_filter(function(req)
	req.ip = req.req.headers["X-Forwarded-For"] or req.headers["X-Real-IP"] or req.req.remote_addr
end)

-- Pages
app:get("boards", "/", utils.reqwrap(require("pages.main")))
app:match("config", "/config", utils.reqwrap(require("pages.config")))
app:match("auth", "/auth", utils.reqwrap(require("pages.auth")))
app:match("admctl", "/admctl", utils.reqwrap(require("pages.adminctl")))
app:get("threads", "/:board", utils.reqwrap(require("pages.threads")))
app:match("newthread", "/:board/new", utils.reqwrap(require("pages.newthread")))
app:match("posts", "/:board/:thread", utils.reqwrap(require("pages.posts")))
app:get("themes", "/themes/:theme", require("pages.themes"))

-- APIs
app:get("api_v0_boards", "/api/v0/boards", require("api.endpoints.v0.boards"))
app:get("api_v0_files", "/api/v0/files", require("api.endpoints.v0.pictures"))
app:get("api_v0_threads", "/api/v0/threads", require("api.endpoints.v0.threads"))
app:get("api_vichan_boards", "/boards.json", utils.reqwrap(require("api.endpoints.vichan.boards")))

function app:handle_404()
	self.path = self.req.parsed_url.path
	return {render = "desktop.404", status = 404}
end

function app:handle_error(err, trace)
	if (self.original_request.route_name:sub(1, 4) == "api_") then
		return {status = 500, json = {err = err, trace = trace}}
	end
	self.err = err
	self.trace = trace
	self.boards = config.luna.boards
	self.boardinfo = config.boardinfo
	self.user = {theme = "classic"}
	return {render = "desktop.error", status = 500}
end

return app
