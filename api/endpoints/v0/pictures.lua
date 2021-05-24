-- Wew.
local config = require("utils.luna-config")
local models = require("models")
return function(req)
	if (req.params.hash) then
		local pictures = models.fileref:select("where blake2 = ?", req.params.hash)
		local retobj = {}
		for i=1, #pictures do
			local pic = pictures[i]
			local posts = {}
			retobj[pic.uuid] = {
				path = pic.filename,
				thumb = pic.thumb,
				mime = pic.mime,
				posts = posts,
				references = pic.refcount
			}
			local plist = models.post:select("where picture = ?", pic.uuid)
			for j=1, #plist do
				local post = plist[j]
				posts[j] = {
					board = post.board,
					thread = post.thread,
					id = post.id,
					content = post.content,
					trip = post.trip,
					date = post.created_at
				}
			end
		end
		return {json = retobj}
	elseif (req.params.uuid) then
		local retobj = {}
		local pic = models.fileref:find(req.params.uuid)
		local posts = {}
		retobj = {
			path = pic.filename,
			thumb = (pic.mime ~= "image/gif") and pic.thumbnail or nil,
			mime = pic.mime,
			posts = posts
		}
		local plist = models.post:select("where picture = ?", pic.uuid)
		for j=1, #plist do
			local post = plist[j]
			posts[j] = {
				board = post.board,
				thread = post.thread,
				id = post.id,
				content = post.content,
				trip = post.trip,
				date = post.created_at
			}
		end
		return {json = {[req.params.uuid] = retobj}}
	end
end
