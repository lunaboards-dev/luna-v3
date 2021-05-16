local db = require("lapis.db")
local config = require("utils.luna-config")
local models = require("models")

return function(req)
	-- Jesus fucking christ.
	local ret = {}
	local boards = config.luna.boards
	for i=1, #boards do
		local board = boards[i]
		local bi = config.boardinfo[board]
		local pages = models.thread:paginated("where board = ?", board, {
			per_page = config.luna.pagesize
		})
		local rt = {
			board = board,
			title = bi.name,
			ws_board = 0,
			per_page = config.luna.pagesize,
			pages = pages:num_pages(),
			max_filesize = config.luna.maxsize or 8192*1024,
			max_webm_filesize = 0, -- not supported, yet
			max_comment_chars = 2000, -- configurable soon:tm:
			max_webm_duration = 0, -- again, not supported.
			bump_limit = 0x7FFFFFFF, -- h a
			image_limit = 0x7FFFFFFF, -- lmao
			cooldowns = {
				threads =  0,
				replies = 0,
				images = 0
			},
			meta_description = "",
			user_ids = 1,
			text_only = bi.noimg and 1 or 0,
			min_image_width = 0,
			min_image_height = 0,
			require_subject = 0,
			webm_audio = 0
		}
		table.insert(ret, rt)
	end
	return {json={boards=ret}}
end
