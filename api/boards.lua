local config = require("utils.luna-config")
local api = ...

function api.getboards()
	return config.boards
end

function api.getboardinfo(board)
	return board and config.board[board] or config.board
end