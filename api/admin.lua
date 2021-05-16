local api = ...

local adm = {}
api.admin = adm

local admin = require("utils.admins")

function adm.delthread(uuid, board, thread)
	if api.checkperms(uuid, board, api.flags.perm_delete_thread) then
		api.deletethread(board, thread)
		return true
	end
	return false
end

function adm.delpost(uuid, id)
	if api.checkperms(uuid, board, api.flags.perm_delete) then
		api.deletepost(id)
		return true
	end
	return false
end

function adm.lockthread(uuid, board, thread, locked)
	if api.checkperms(uuid, board, api.flags.perm_lock) then
		api.lockthread(board, thread, locked)
		return true
	end
	return false
end

function adm.pinthread(uuid, board, thread, level)
	if api.checkperms(uuid, board, api.flags.perm_pin) then
		api.pinthread(board, thread, level)
		return true
	end
	return false
end

function adm.markthread(uuid, board, thread, marked)
	if api.checkperms(uuid, board, api.flags.perm_mark) then
		api.markthread(board, thread, marked)
		return true
	end
	return false
end

-- I forgot the IP ban DB, huh?
function adm.ban(uuid, ip)

end
