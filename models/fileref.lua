local Model = require("lapis.db.model").Model

return Model:extend("filereftrack", {
	primary_key = "uuid"
})
