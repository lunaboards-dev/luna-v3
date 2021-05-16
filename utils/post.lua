local post = {}

local formatters = {
	function(line)
		if line:sub(1, 1) == ">" then
			return '<span class="quote glow">&gt;'..line:sub(2):gsub("^%s", "")..'</span>'
		end
		return line
	end,
	function(line)
		return line.."<br>"
	end
}

function post.format(post)
	if (post:sub(#post) ~= "\n") then post = post .. "\n" end
	local s = ""
	for line in post:gmatch("[^\n]+") do
		for i=1, #formatters do
			line = formatters[i](line)
		end
		s = s .. line
	end
	return s
end

return post
