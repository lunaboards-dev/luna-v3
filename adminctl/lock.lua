return function(req)
	if not api.admin.lockthread(req.admin, req.params.board, req.params.thd, not api.islocked(req.params.board, req.params.thd)) then
		return {status = 403, "flag PERM_LOCK not set"}
	end
end
