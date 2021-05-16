local config = require("utils.luna-config")
local models = require("models")
return function(req)
	local obj = {}
	for i=1, #config.luna.boards do
		local board = config.luna.boards[i]
		local boardinfo = config.boardinfo[board]
		table.insert(obj, {
			id = board,
			name = boardinfo.name,
			thread_count = #models.thread:select("where board = ?", board),
			textonly = boardinfo.noimg or false
		})
	end
	return {json = obj}
end
