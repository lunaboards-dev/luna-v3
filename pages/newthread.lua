local respond_to = require("lapis.application").respond_to
return respond_to {
	GET = function(self)
		return {render = "desktop.create_thread"}
}