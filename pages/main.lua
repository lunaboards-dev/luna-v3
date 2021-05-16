local cfg = require("utils.luna-config")
return function(req)
	req.opengraph = {
		title = "luna - late night shitposting",
		url = cfg.luna.url
	}
	return {render = "desktop.boards"}
end
