local config = require("utils.luna-config")
local util = require("utils")
local files = require("utils.files")
local models = require("models")
local db = require("lapis.db")
local api = ...

function api.getpostid(board, thread)
	local id = db.select("max(id) from posts", board, thread)[1].max
	if type(id) ~= "number" then
		return 1
	else
		return id+1
	end
end

function api.newpost(args)
	if (api.ismarked(args.board, args.thread) or api.islocked(args.board, args.thread)) and not args.force then return end
	args.body = args.body or "wtf is a poland"
	args.body = args.body:sub(1, 2000):gsub("[\r\n]+", function(match)
		match = match:gsub("\r\n", "\n"):gsub("\r", "\n")
		if (#match > 2) then
			return "\n\n"
		end
	end)
	if (args.trip and args.trip ~= "") then
		local tc, key = args.trip:match("([^#]+)#(.+)")
		if not tc or not key then
			args.trip = util.tripcode(args.ip, args.title)
		else
			-- calculate tripcode
			args.trip = tc.."!"..util.tripcode(tc..key, config.luna.tripsalt)
		end
	else
		io.stdout:write("\n\n\n",tostring(args.ip),"\n\n\n")
		args.trip = util.tripcode(args.ip, args.title..args.thread)
	end
	if args.picture then
		api.upload_picture(args)
	end
	if not args.picture and args.body == "" then
		args.body = "wtf is a poland"
	end
	local thd = models.thread:find(args.board, args.thread)
	thd.count = thd.count+1
	thd:update("count", {
		timestamp = args.timestamp
	})
	return models.post:create({
		board = args.board,
		thread = args.thread,
		id = api.getpostid(args.board, args.thread),
		trip = args.trip,
		admin = args.admin,
		content = args.body,
		picture = args.picture,
		original_name = args.original_picture,
		ip = args.ip
	})
end

function api.deletepost(id)
	local post = models.post:select("where id = ?", id)[1]
	if (post.picture and post.picture ~= "") then
		files.decref(post.picture)
	end
	local thd = models.thread:find(post.board, post.thread)
	thd.count = thd.count - 1
	thd:update("count", {
		timestamp = false
	})
	post:delete()
end

function api.getposts(board, thread)
	return models.post:select("where board = ? and thread = ? order by id asc, updated_at desc", board, thread)
end

function api.islocked(board, thread)
	return bit.band(models.thread:find(board, thread).flags, api.flags.thread_locked) > 0
end

function api.ismarked(board, thread)
	return bit.band(models.thread:find(board, thread).flags, api.flags.thread_marked) > 0
end

function api.pinlevel(board, thread)
	return models.thread:find(board, thread).pin
end

function api.lockthread(board, thread, locked)
	local thd = models.thread:find(board, thread)
	local mask = bit.bxor(0x7FFFFFFF, api.flags.thread_locked)
	thd.flags = bit.bor(bit.band(mask, thd.flags), locked and api.flags.thread_locked or 0)
	thd:update("flags", {
		timestamp = false
	})
end

function api.markthread(board, thread, marked)
	local thd = models.thread:find(board, thread)
	local mask = bit.bxor(0x7FFFFFFF, api.flags.thread_marked)
	thd.flags = bit.bor(bit.band(mask, thd.flags), marked and api.flags.thread_marked or 0)
	thd:update("flags", {
		timestamp = false
	})
end

function api.pinthread(board, thread, level)
	local thd = models.thread:find(board, thread)
	thd.pin = level
	thd:update("pin", {
		timestamp = false
	})
end
