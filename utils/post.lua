local post = {}
local models = require("models")
local db = require("lapis.db")

function post.format(post, src)
	local formatters = { -- GAH FUCKING AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		function(line, src)
			local nline = ""
			local st, en = 0, 0
			local oen = 0
			repeat
				st, en = line:find(">>%d+", en+1)
				if st then
					nline = nline .. line:sub(oen, st-1)
					local id = line:sub(st+2, en)
					oen = en+1
					if id ~= "" then
						local post = models.post:select("where id = ?", tonumber(id))[1]
						if post then
							if (post.board == src.board and post.thread == src.thread) then
								nline = nline .. "<a class=\"quote glow\" href=\"#post_"..id.."\">&gt;&gt;"..id.."</a>"
							elseif (post.board == src.board) then
								nline = nline ..  "<a class=\"quote glow\" href=\"/"..post.board.."/"..post.thread.."#post_"..id.."\">&gt;&gt;"..post.thread.."#"..id.."</a>"
							else
								nline = nline ..  "<a class=\"quote glow\" href=\"/"..post.board.."/"..post.thread.."#post_"..id.."\">&gt;&gt;/"..post.board.."/"..post.thread.."#"..id.."</a>"
							end
						else
							nline = nline .. "&gt;&gt;"..id
						end
					else
						nline = nline .. "&gt;&gt;"
					end
				end
			until not st
			nline = nline .. line:sub(oen)
			return nline
			--[[return line:gsub(">>(%d+)", function(id)
				local post = models.post:find(tonumber(id))
				if post then
					if (post.board == src.board and post.thread == src.thread) then
						return "<a class=\"quote glow\" href=\"#post_"..id.."\">&gt;&gt;"..id.."</a>"
					elseif (post.board == src.board) then
						return "<a class=\"quote glow\" href=\"/"..post.board.."/"..post.thread.."#post_"..id.."\">&gt;&gt;"..post.thread.."#"..id.."</a>"
					end
					return "<a class=\"quote glow\" href=\"/"..post.board.."/"..post.thread.."#post_"..id.."\">&gt;&gt;/"..post.board.."/"..post.thread.."#"..id.."</a>"
				end
				return "&gt;&gt;"..id
			end)]]
		end,
		function(line, src)
			if line:sub(1, 1) == ">" then
				return '<span class="quote glow">&gt;'..line:sub(2):gsub("^%s", "")..'</span>'
			end
			return line
		end,
		function(line, src)
			return line.."<br>"
		end,
		function(line, src)
			return line:gsub("\1", "")
		end
	}

	if (post:sub(#post) ~= "\n") then post = post .. "\n" end
	local s = ""
	for line in post:gmatch("[^\n]+") do
		for i=1, #formatters do
			line = formatters[i](line, src)
		end
		s = s .. line
	end

	-- Get replies to this post
	local repls = models.post:select("where content like ?", "%>>"..src.id.."%")
	local real_repls = {}
	for i=1, #repls do
		local ms, me = repls[i].content:find(">>"..src.id)
		local sub = repls[i].content:sub(ms, me+1)
		if (sub == ">>"..src.id.." " or sub == ">>"..src.id) then
			real_repls[#real_repls+1] = repls[i]
		end
	end
	src.replies = real_repls
	return s
end

return post
