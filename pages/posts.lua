local respond_to = require("lapis.application").respond_to
local cfg = require("utils.luna-config")
local files = require("utils.files")
return respond_to {
	GET = function(req)
		local thd = api.getthread(req.params.board, req.params.thread)
		if not thd then
			return req.app.handle_404(req)
		end
		req.sboard = req.params.board
		req.sthreadid = req.params.thread
		req.threads = api.getthreads(req.params.board, req.params.page or 0, req.params.pagesize)
		req.posts = api.getposts(req.params.board, req.params.thread)
		req.thread = thd
		req.opengraph = {
			title = string.format("luna/%s/ - %s", req.params.board, thd.name),
			url = string.format("%s/%s/%s", cfg.luna.url, req.params.board, req.params.thread),
			desc = req.posts[1].content,
			image = string.format("%s%s", cfg.luna.url, req.posts[1].picture and files.getnames(req.posts[1].picture) or "/static/moooon.png")
		}

		return {render = "desktop.posts", code = req.thread and 200 or 404}
	end,
	POST = function(req)
		local args = req.params
		args.force = false -- no
		args.admin = req.admin
		--args.ip = req.req.remote_addr
		args.ip = req.ip
		--io.stdout:write("\n\n\n",tostring(args.ip),"\n\n\n")
		local thd = api.getthread(args.board, args.thread)
		if not thd then
			return req.app.handle_404(req)
		end
		args.title = api.getthread(args.board, args.thread).name

		api.newpost(args)
		return {redirect_to = req:build_url("/"..args.board.."/"..args.thread, {
			status = 302
		})}
	end
}
