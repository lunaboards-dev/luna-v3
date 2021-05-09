local models = require("models")
--local api = require("api")

return function(req)
	--req.threads = models.thread:select("where board = ?", req.params.board)
	req.threads = api.getthreads(req.params.board, req.params.page or 0, req.params.pagesize)
	req.sboard = req.params.board
	return {render = "desktop.threads"}
end
