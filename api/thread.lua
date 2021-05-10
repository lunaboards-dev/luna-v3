local config = require("utils.luna-config")
local util = require("utils")
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
	args.body = args.body or "wtf is a poland"
	args.body = args.body:sub(1, 2000):gsub("[\r\n]+", function(match)
		match = match:gsub("\r\n", "\n"):gsub("\r", "\n")
		if (#match > 2) then
			return "\n\n"
		end
	end)
	if (args.trip and args.trip ~= "") then
		local tc, key = args.trip:match("(%w+)#(.+)")
		if not tc or not key then
			args.trip = util.tripcode(args.ip, args.title)
		else
			-- calculate tripcode
			args.trip = tc.."!"..util.tripcode(key, config.luna.tripsalt)
		end
	else
		io.stdout:write("\n\n\n",tostring(args.ip),"\n\n\n")
		args.trip = util.tripcode(args.ip, args.title)
	end
	if args.picture then
		api.upload_picture(args)
	end
	local thd = models.thread:find(args.board, args.thread)
	thd.count = thd.count+1
	thd:update("count")
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

function api.getposts(board, thread)
	return models.post:select("where board = ? and thread = ? order by id asc, updated_at desc", board, thread)
end
