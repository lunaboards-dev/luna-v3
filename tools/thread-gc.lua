local db = require("lapis.db")
local models = require("models")
local files = require("utils.files")
local config = require("utils.luna-config")
local db = require("lapis.db")
local bit = bit or require("bit")
local api = require("api.init")

if not config.threadgc.enabled then print("threadgc disabled, exiting") return end
local lock_date = db.format_date(os.time(os.date("!*t"))-config.threadgc.lock_age)
local delete_date = db.format_date(os.time(os.date("!*t"))-config.threadgc.delete_age)
local threadgc_uuid = models.admin:select("where name = ?", "THREAD-GC")[1]

local thds = models.thread:select("where updated_at < ?", lock_date)
for _, thread in ipairs(thds) do
	if (bit.band(thread.flags, api.flags.thread_nogc) or thread.pin > 0) then
		goto continue
	end
	thread.flags = bit.bor(thread.flags, api.flags.thread_locked)
	thread:update("flags", {
		timestamp = false
	})
	api.newpost {
		body = "Thread has been locked.",
		admin = threadgc_uuid.uuid,
		board = thread.board,
		thread = thread.id,
		ip = "",
		timestamp = false
	}
	::continue::
end

thds = models.thread:select("where updated_at < ?", delete_date)
for _, thread in ipairs(thds) do
	if (bit.band(thread.flags, api.flags.thread_nogc) or thread.pin > 0) then
		goto continue
	end
	api.deletethread(thread.board, thread.id)
	::continue::
end

thds = models.thread:select("where flags & ? > 0", api.flags.thread_marked)
for _, thread in ipairs(thds) do
	api.deletethread(thread.board, thread.id)
end

thds = models.thread:select("where flags & ? > 0", api.flags.thread_tolock)
for _, thread in ipairs(thds) do
	thread.flags = bit.bxor(bit.bor(thread.flags, api.flags.thread_locked), api.flags.thread_tolock)
	thread:update("flags", {
		timestamp = false
	})
	api.newpost {
		body = "Thread has been locked.",
		admin = threadgc_uuid.uuid,
		board = thread.board,
		thread = thread.id,
		ip = "",
		title = thread.name,
		timestamp = false
	}
end

print("thread-gc complete.")
