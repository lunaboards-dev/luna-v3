local config = require("utils.luna-config")
local models = require("models")
local api = ...

local threadflags = {
	creating = 1,
	locked = 2,
	marked_for_deletion = 4
}

local validators = {}

function api.getthreads(board, page, pagesize)
	local pages = models.thread:paginated("where board = ? order by pin desc, updated_at desc, name asc", board, {
		per_page = pagesize or 50
	})
	return pages:get_page(page)
end

function api.threadexists(board, id)
	return #models.thread:select("where board = ? and id = ?", board, id) > 0
end

function api.getthread(board, id)
	return models.thread:select("where board = ? and id = ?", board, id)[1]
end

local bit = require("bit")

function api.newthreadid(board)
	local r = io.open("/dev/urandom", "r")
	local id = ""
	repeat
		local t = r:read(config.luna.id_size or 6)
		id = ""
		for i=1, #t do
			id = id .. string.format("%.2x", t:byte(i))
		end
	until not api.threadexists(board, id)
	return id
end


function api.newthread(args)
	args.title = args.title or "i'm a lazy cunt"
	args.body = args.body or "wtf is a poland"
	args.title = args.title:sub(1, 32)
	args.body = args.body:sub(1, 2000):gsub("[\r\n]+", function(match)
		match = match:gsub("\r\n", "\n"):gsub("\r", "\n")
		if (#match > 2) then
			return "\n\n"
		end
	end)
	if (config.boardinfo[args.board].thread_validate) then
		-- run thread validation
		if not validators[config.boardinfo[args.board].thread_validate] then
			validators[config.boardinfo[args.board].thread_validate] = dofile(config.boardinfo[args.board].thread_validate)
		end
		validators[config.boardinfo[args.board].thread_validate](args)
	end
	args.thread = api.newthreadid(args.board)
	models.thread:create({
		board = args.board,
		id = args.thread,
		name = args.title,
		pin = 0,
		ip = args.ip,
		count = 0,
		flags = threadflags.creating
	})
	api.newpost(args)
	local thd = models.thread:find(args.board, args.thread)
	thd.flags = 0
	thd:update("flags")
	return args.thread
end
