local respond_to = require("lapis.application").respond_to

return respond_to {
	GET = function(req)
		return {render = "desktop.config"}
	end,
	POST = function(req)
		return {render = "desktop.config"}
	end
}
