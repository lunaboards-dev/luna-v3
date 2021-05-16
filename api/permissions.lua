local models = require("models")
local api = ...
api.flags.perm_lock = 1
api.flags.perm_mark = 2
api.flags.perm_delete = 4
api.flags.perm_html = 8
api.flags.perm_pin = 16
api.flags.perm_grant = 32
api.flags.perm_delete_thread = 64
api.flags.perm_ban = 128
api.flags.perm_viewip = 256

local bit = bit or require("bit")

function api.getperms(uuid, board)
	return bit.bor(board and api.getboardperms(uuid, board) or 0, api.getglobalperms(uuid))
end

function api.getboardperms(uuid, board)
	local boardperm = models.adminperms:find(uuid, board)
	if not boardperm then
		boardperm = models.adminperms:create({
			board = board,
			uuid = uuid,
			flags = 0
		})
	end
	return boardperm.flags
end

function api.getglobalperms(uuid)
	local admin = models.admin:find(uuid)
	return admin.flags
end

function api.enableperm(uuid, bits, board)
	local perms
	if board then
		api.getboardperms(uuid, board)
		perms = models.adminperms:find(uuid, board)
	else
		perms = models.admin:find(uuid)
	end
	perms.flags = bit.bor(perms.flags, bits)
	perms:update("flags")
	return perms.flags
end

function api.disableperm(uuid, bits, board)
	local mask = bit.bxor(bits, 0x7FFFFFFF)
	local perms
	if board then
		api.getboardperms(uuid, board)
		perms = models.adminperms:find(uuid, board)
	else
		perms = models.admin:find(uuid)
	end
	perms.flags = bit.band(perms.flags, mask)
	perms:update("flags")
	return perms.flags
end

function api.checkperms(uuid, board, ...)
	local perms = {...}
	local mask = 0
	for i=1, #perms do
		mask = bit.bor(mask, perms[i])
	end
	local pcheck = api.getperms(uuid, board)
	return bit.band(pcheck, mask) == mask
end
