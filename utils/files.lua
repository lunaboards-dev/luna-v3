local files = {}
local utils = require("utils")
local blake2b = require("utils.blake2b")
local models = require("models")
local lfs = require("lfs")

-- The be all-catch all
function files.getuuid(ext, content, mime)
	local hash = blake2b.hash(content, 32, nil, "hex")
	local refs = models.fileref:select("where blake2 = ?", hash)
	if #refs > 0 then -- Best to assume collisions may happens at some point and some time
		for i=1, #refs do -- Because you never really know if they will
			local h = io.open(refs[i].filename, "r")
			local dat = h:read("*a")
			h:close()
			if (h == fdat) then
				return refs[i].uuid
			end
		end
	end
	local uuid = utils.uuid()
	local f = io.open("uploads/full/"..uuid.."."..ext, "w")
	f:write(content)
	f:close()
	os.execute("convert uploads/full/"..uuid.."."..ext.." -resize 500x500\\> uploads/thumbs/"..uuid.."."..ext)
	models.fileref:create({
		filename = "/uploads/full/"..uuid.."."..ext,
		thumbnail = "/uploads/thumbs/"..uuid.."."..ext,
		blake2 = hash,
		uuid = uuid,
		ext = ext,
		mime = mime
	})
	return uuid
end

function files.getnames(uuid)
	local ref = models.fileref:find(uuid)
	return ref.filename, ref.thumbnail, ref.ext, ref.mime
end

function files.incref(uuid)
	local ref = models.fileref:find(uuid)
	refs.refcount = refs[i].refcount + 1
	refs:update("refcount")
	return refs.refcount
end

function files.remove(uuid)
	local ref = models.fileref:find(uuid)
	os.remove(refs.filename)
	os.remove(refs.thumbnail)
	ref:delete()
end

function files.decref(uuid)
	local ref = models.fileref:find(uuid)
	refs.refcount = refs[i].refcount - 1
	refs:update("refcount")
	if (refs == 0) then
		files.remove(uuid)
	end
	return refs.refcount
end

function files.getsize(uuid)
	local ref = models.fileref:find(uuid)
	io.stdout:write("\n\n\n",assert(lfs.attributes(ref.filename:sub(2), "size")),"\n\n\n")
	return assert(lfs.attributes(ref.filename:sub(2), "size"))
end

return files
