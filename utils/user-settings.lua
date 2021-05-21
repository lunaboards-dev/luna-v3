local settings = {}

function settings.load(req)
	req.session.user = req.session.user or {}
	req.user = req.session.user
end

return settings
