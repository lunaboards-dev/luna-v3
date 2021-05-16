local cfg = require("utils.luna-config")
return function(req)
	req.opengraph = {
		title = "luna - late night shitposting",
		url = cfg.luna.url,
		image = string.format("%s%s", cfg.luna.url, "/static/moooon.png"),
	}
	return {render = "desktop.boards"}
end
