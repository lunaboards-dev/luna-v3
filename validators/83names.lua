local sfn_char = "[A-Z0-9!#$%%&'%(%)%-@^_`{}~]?"
local sfn_char_i = "[^A-Z0-9!#$%%&'%(%)%-@^_`{}~]"
local model = require("models")
local function thread_name_exists(board, name)
	return #model.thread:select("where board = ? and name = ?", board, name) > 0
end

local function p83(name, ext)
	if not ext or ext == "" then return name:upper() end
	return (name .. "." .. ext):upper()
end

local function to83(name, i)
	i = i or 0
	name = name:gsub(sfn_char_i, "")
	local bname, ext = name:match("([^%.]+)%.(.+)")
	if not bname then bname = name ext = "" end
	ext = ext:sub(1, 3)
	if (#bname == 8 and i == 0) then
		return p83(bname, ext)
	end
	local si = string.format("~%X", i)
	local sname = bname:sub(1, 8-#si)..si
	return p83(sname, ext), i+1
end
return function(thread)
	thread.title = thread.title:upper()
	if not thread.title:match(string.format("^%s%%.?%s$", string.rep(sfn_char, 8), string.rep(sfn_char, 3))) or thread_name_exists(thread.board, thread.title) then
		-- Convert to 8.3 file name
		local name
		local i = 0
		repeat
			name, i = to83(thread.title, i)
		until not thread_name_exists(thread.board, name)
		thread.title = name
		-- procede
	end
	return true
end
