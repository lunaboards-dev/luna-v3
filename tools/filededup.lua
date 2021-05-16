local db = require("lapis.db")
local models = require("models")
local futil = require("utils.files")

local function readfile(path)
	return io.open(path, "r"):read("*a")
end

local function compare(file1, file2)
	return readfile(file1.filename:sub(2)) == readfile(file2.filename:sub(2))
end

local files = models.fileref:select("")

local unique_hashes = {}
local non_unique_uuids = {}
for i=1, #files do
	local file = files[i]
	print("checking: "..file.uuid)
	if not unique_hashes[file.blake2] then
		print("unique: "..file.uuid)
		unique_hashes[file.blake2] = {file}
		goto continue
	end
	for j=1, #unique_hashes[file.blake2] do
		print(string.format("comparing %s and %s", file.uuid, unique_hashes[file.blake2][j].uuid))
		if compare(unique_hashes[file.blake2][j], file) then
			print(string.format("found duplicate file %s (duplicate of %s, hash: %s)", file.uuid, unique_hashes[file.blake2][j].uuid, file.blake2))
			non_unique_uuids[file.uuid] = unique_hashes[file.blake2][j].uuid
			goto continue
		end
	end
	table.insert(unique_hashes[file.blake2], file)
	::continue::
end

for old, new in pairs(non_unique_uuids) do
	print(string.format("replacing all instances of %s with %s", old, new))
	local posts = models.post:select("where picture = ?", old)
	for j=1, #posts do
		posts[j].picture = new
		posts[j]:update("picture")
		print(string.format("updated %d", posts[j].id))
	end
	futil.remove(old)
end
