return function(req, code, err, info)
	return {json = {
		error = err,
		info = info
	}, code = code}
end
