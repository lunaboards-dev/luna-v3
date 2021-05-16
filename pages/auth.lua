local models = require("models")
local respond_to = require("lapis.application").respond_to
local utils = require("utils")
local admins = require("utils.admins")
return respond_to {
	GET = function(req)

		return {render = "desktop.auth"}
	end,
	POST = function(req)
		local adm = admins.authenticate(req.params.username, req.params.password)
		if (adm) then
			adm.old_token = adm.token
			adm.token = utils.uuid()
			adm:update("token", "old_token")
			req.session.admin = adm.token
			req.session.message = "<span class=\"success\">Login successful.</span>"
			return {redirect_to = req:build_url("/", {
				status = 302
			})}
		else
			req.session.message = "<span class=\"error\">Invalid username or password.</span>"
			req.message = "<span class=\"error\">Invalid username or password.</span>"
			return {redirect_to = req:build_url("/", {
				status = 302
			})}
		end
	end
}
