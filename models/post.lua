local Model = require("lapis.db.model").Model

return Model:extend("posts", {
	primary_key = {"board", "thread", "id"},
	timestamp = true
})
