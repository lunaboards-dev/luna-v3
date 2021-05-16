local models = require("models")
local respond_to = require("lapis.application").respond_to
local cfg = require("utils.luna-config")
return respond_to {
	GET = function(req)
		if not cfg.boardlookup[req.params.board] then
			return req.app.handle_404(req)
		end
		req.threads = models.thread:select("where board = ?", req.params.board)
		req.sboard = req.params.board
		return {render = "desktop.create_thread"}
	end,
	POST = function(req)
		local args = req.params
		args.admin = req.admin
		--args.ip = req.req.remote_addr
		args.ip = req.ip
		if not cfg.boardlookup[req.params.board] then
			return req.app.handle_404(req)
		end
		local id = api.newthread(args, req.params)
		if not id then
			req.session.message = [[<span class="error">Invalid arguments</span>]]
			{redirect_to = req:build_url(req.req.headers.referer, {
				status = 302
			})}
		end
		return {redirect_to = req:build_url("/"..args.board.."/"..id, {
			status = 302
		})}
	end
}
