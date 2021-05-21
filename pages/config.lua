local respond_to = require("lapis.application").respond_to

return respond_to {
	GET = function(req)
		return {render = "desktop.config"}
	end,
	POST = function(req)
		req.session.user.js = req.params.js_enabled == "on"
		req.session.user.js = req.params.theme
		return {render = "desktop.config"}
	end
}
