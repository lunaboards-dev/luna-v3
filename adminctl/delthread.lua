return function(req)
	if not api.admin.delthread(req.admin, req.params.board, req.params.thd) then
		return {status = 403, "flag PERM_DELETE_THREAD not set"}
	end
end
