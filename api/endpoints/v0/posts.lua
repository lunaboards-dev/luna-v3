local models = require("models")
local config = require("utils.luna-config")
local admins = require("utils.admins")

return function(req)
	if not config.boardlookup[req.params.board] then
		return require("api.endpoints.v0.error")(req, 400, "invalid board", string.format("board %q not found", req.params.board))
	end
	if not api.getthread(req.params.board, req.params.thread) then
		return require("api.endpoints.v0.error")(req, 400, "invalid thread", string.format("thread %q not found on board %q", req.params.thread, req.params.board))
	end

	local posts = api.getposts(req.params.board, req.params.thread)
	local retvals = {}
	for i=1, #posts do
		local post = posts[i]
		local ret = {
			id = post.id,
			date = post.created_at,
			trip = post.trip,
			content = post.content,
			picture = post.picture,
			original_name = post.original_name
		}
		if (post.admin) then
			ret.admin = {
				name = admins.getdisplayname(post.admin),
				color = admins.getcolor(post.admin)
			}
		end
		ret.ip = (req.admin and api.checkperms(req.admin, req.params.board, api.flags.perm_viewip)) and post.ip or nil

		-- Process replies/replies_to
		local repl_to = post.replies_to
		local rt = {}
		for j=1, #repl_to do
			local repl = repl_to[j]
			local r = {
				id = repl.id,
				board = repl.board,
				thread = repl.thread,
				trip = repl.trip,
				content = repl.content,
				picture = repl.picture,
				original_name = repl.original_name,
				date = post.created_at
			}
			if (repl.admin) then
				r.admin = {
					name = admins.getdisplayname(repl.admin),
					color = admins.getcolor(repl.admin)
				}
			end
			r.ip = (req.admin and api.checkperms(req.admin, req.params.board, api.flags.perm_viewip)) and repl.ip or nil
			table.insert(rt, r)
		end
		ret.replies_to = rt

		local repls = post.replies
		local rs = {}
		for j=1, #repls do
			local repl = repls[j]
			local r = {
				id = repl.id,
				board = repl.board,
				thread = repl.thread,
				trip = repl.trip,
				content = repl.content,
				picture = repl.picture,
				original_name = repl.original_name,
				date = post.created_at
			}
			if (repl.admin) then
				r.admin = {
					name = admins.getdisplayname(repl.admin),
					color = admins.getcolor(repl.admin)
				}
			end
			r.ip = (req.admin and api.checkperms(req.admin, req.params.board, api.flags.perm_viewip)) and repl.ip or nil
			table.insert(rs, r)
		end
		ret.replies = rs

		table.insert(retvals, ret)
	end
	return {json=retvals}
end
