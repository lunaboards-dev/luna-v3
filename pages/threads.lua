local models = require("models")

return function(req)
	req.threads = models.thread:select("where board = ?", req.params.board)
	req.sboard = req.params.board
	return {render = "desktop.threads"}
end