local models = require("models")
local config = require("utils.luna-config")
return function(req)
	local threads
	if req.params.board then
		if not config.boardlookup[req.params.board] then
			return require("api.endpoints.v0.error")(req, 400, "invalid board", string.format("board %q not found", req.params.board))
		end
		threads = models.thread:select("where board = ? order by pin desc, updated_at desc, name asc", req.params.board)
	else
		threads = models.thread:select("")
	end
	local ret = {}
	for i=1, #threads do
		local thread = threads[i]
		local tobj = {}
		if (req.admin and api.checkperms(req.admin, req.params.board, api.flags.perm_viewip)) then
			tobj.ip = thread.ip
		end
		tobj.name = thread.name
		tobj.created = thread.created_at
		tobj.last_update = thread.updated_at
		tobj.posts = thread.count
		tobj.board = thread.board
		tobj.id = thread.id
		tobj.locked = api.islocked(thread.board, thread.id)
		tobj.marked = api.islocked(thread.board, thread.id)
		tobj.pinned = api.pinlevel(thread.board, thread.id)
		local op = models.post:select("where board = ? and thread = ? order by id asc", thread.board, thread.id)[1]
		tobj.op = {
			trip = op.trip,
			date = op.created_at,
			content = op.content,
			picture = op.picture,
			original_name = op.original_name,
			ip = (req.admin and api.checkperms(req.admin, req.params.board, api.flags.perm_viewip)) and op.ip or nil
		}
		ret[i] = tobj
	end
	return {json = ret}
end
