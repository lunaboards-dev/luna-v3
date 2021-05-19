local api = ...
local blake2b = require("utils.blake2b")
local models = require("models")
local files = require("utils.files")
local cfg = require("utils.luna-config")

function api.upload_picture(args)
	local fdat = args.picture.content
	local fname = args.picture.filename
	local mime = args.picture["content-type"]
	if not fdat or #fdat == 0 or cfg.boardinfo[args.board].noimg then args.picture = nil return end
	for k, v in pairs(args.picture) do
		print(k)
	end
	local mimeclass, type = mime:match("^([^/]+)/(.+)")
	if mimeclass ~= "image" then args.picture = nil end
	local ext = fname:match("%.(.+)$")
	local uuid = files.getuuid(ext, fdat, mime)
	args.picture = uuid
	args.original_picture = fname
	files.incref(uuid)
end
