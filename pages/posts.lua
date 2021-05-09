local respond_to = require("lapis.application").respond_to
return respond_to {
	GET = function(req)
		req.sboard = req.params.board
		req.sthreadid = req.params.thread
		req.threads = api.getthreads(req.params.board, req.params.page or 0, req.params.pagesize)
		req.posts = api.getposts(req.params.board, req.params.thread)
		req.thread = api.getthread(req.params.board, req.params.thread)

		return {render = "desktop.posts"}
	end,
	POST = function(req)
		local args = req.params
		args.admin = req.admin
		args.ip = req.req.remote_addr
		io.stdout:write("\n\n\n",tostring(args.ip),"\n\n\n")
		args.title = api.getthread(args.board, args.thread).name
		api.newpost(args)
		return {redirect_to = req:build_url("/"..args.board.."/"..args.thread, {
			status = 302
		})}
	end
}
