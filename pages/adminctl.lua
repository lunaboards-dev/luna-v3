-- Admin control panel
local adminctl = require("adminctl")
return function(req)
	if not req.admin then
		return {status = 403, "no auth"}
	end
	if not req.params.cmd then
		return {status = 400, "no command"}
	end
	local ret = adminctl[req.params.cmd](req)
	if ret then return ret end
	return {redirect_to = req:build_url(req.req.headers.referer, {
		status = 302
	})}
end
