local name, pass = ...
local db = require("lapis.db")
local models = require("models")
local utils = require("utils")
local config = require("utils.luna-config")
local bcrypt = require("bcrypt")
models.admin:create({
	uuid = utils.uuid(),
	name = name,
	color = "pink",
	ranktext = "BOT",
	flags = 0x7FFFFFFF,
	passhash = bcrypt.digest(pass, config.bcrypt.rounds),
	token = "",
	old_token = ""
})
