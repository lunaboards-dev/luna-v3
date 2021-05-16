-- Deletes a post
return function(req)
	if not api.admin.delpost(req.admin, req.params.post) then
		return {status = 403, "flag PERM_DELETE not set"}
	end
end
