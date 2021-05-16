local name = ...
local db = require("lapis.db")
local models = require("models")
local utils = require("utils")

models.admin:create({
	uuid = utils.uuid(),
	name = name,
	color = "pink",
	ranktext = "BOT",
	flags = 0x7FFFFFFF,
	passhash = "",
	token = "",
	old_token = ""
})
