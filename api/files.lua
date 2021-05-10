local api = ...
local blake2b = require("utils.blake2b")
local models = require("models")
local files = require("utils.files")

function api.upload_picture(args)
	local fdat = args.picture.content
	local fname = args.picture.filename
	local mime = args.picture["content-type"]
	local mimeclass, type = mime:match("^([^/]+)/(.+)")
	if mimeclass ~= "image" then args.picture = nil end
	local ext = fname:match("%.(.+)$")
	local uuid = files.getuuid(ext, fdat, mime)
	args.picture = uuid
	args.old_picture = fname
end
