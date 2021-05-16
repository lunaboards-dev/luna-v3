return function(req)
	if not api.admin.markthread(req.admin, req.params.board, req.params.thd, not api.ismarked(req.params.board, req.params.thd)) then
		return {status = 403, "flag PERM_MARK not set"}
	end
end
