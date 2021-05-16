local models = require("models")
local config = require("utils.luna-config")

return function(req)
	if not config.boardlookup[req.params.board] then
		return require("api.endpoints.v0.error")(req, 400, "invalid board", string.format("board %q not found", req.params.board))
	end
end
