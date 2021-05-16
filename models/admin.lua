local Model = require("lapis.db.model").Model

return Model:extend("admins", {
	primary_key = "uuid"
})
