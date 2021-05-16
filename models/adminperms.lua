local Model = require("lapis.db.model").Model

return Model:extend("adminpriv", {
	primary_key = {"uuid", "board"}
})
