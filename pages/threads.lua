local models = require("models")
--local api = require("api")
local cfg = require("utils.luna-config")

return function(req)
	--req.threads = models.thread:select("where board = ?", req.params.board)
	if not cfg.boardlookup[req.params.board] then
		return req.app.handle_404(req)
	end
	req.threads = api.getthreads(req.params.board, req.params.page or 0, req.params.pagesize or cfg.luna.pagesize)
	req.sboard = req.params.board
	req.opengraph = {
		title = string.format("luna/%s/ - %s", req.params.board, cfg.boardinfo[req.params.board].name),
		url = string.format("%s/%s", cfg.luna.url, req.params.board)
	}
	return {render = "desktop.threads"}
end
