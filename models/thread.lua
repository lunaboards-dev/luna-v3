local Model = require("lapis.db.model").Model

return Model:extend("threads", {
	primary_key = {"board", "id"},
	timestamp = true
})
