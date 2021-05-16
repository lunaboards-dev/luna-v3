local admins = {}
local models = require("models")
local bcrypt = require("bcrypt")

function admins.getdisplayname(uuid)
	local adm = models.admin:find(uuid)
	return adm.ranktext .. "." .. adm.name
end

function admins.getcolor(uuid)
	return models.admin:find(uuid).color
end

function admins.authenticate(username, password)
	local admin = models.admin:select("where name = ?", username)[1]
	if not admin then return false end
	return bcrypt.verify(password, admin.passhash) and admin
end

function admins.checkauth(token)
	if not token then return end
	local adm = models.admin:select("where token = ? or old_token = ?", token, token)[1]
	return adm
end

function admins.authfilter(req)
	local adm = admins.checkauth(req.session.admin)
	if adm then
		req.adm = adm
		req.admin = adm.uuid
	else
		req.session.admin = nil
	end
end

return admins
