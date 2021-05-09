local models = require("models")
local respond_to = require("lapis.application").respond_to
return respond_to {
	GET = function(req)
		req.threads = models.thread:select("where board = ?", req.params.board)
		req.sboard = req.params.board
		return {render = "desktop.create_thread"}
	end,
	POST = function(req)
		local args = req.params
		args.admin = req.admin
		args.ip = req.req.remote_addr
		local id = api.newthread(args, req.params)
		return {redirect_to = req:build_url("/"..args.board.."/"..id, {
			status = 302
		})}
	end
}
