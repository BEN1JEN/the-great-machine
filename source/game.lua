local serialize = require "serialize"
local game = {}

function game.new(address)
	local host = require("enet").host_create()
	host:connect(address)
	return setmetatable({
		font = require("font").new("assets/font.png", 80, 45),
		host = host,
	}, {__index=game})
end

function game:update(delta, input)
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			print("recieve", serialize.deserialize(event.data))
		elseif event.type == "connect" then
		elseif event.type == "disconnect" then
		end
		event = self.host:service()
	end
end

function game:draw()
	local width, height = love.window.getMode()
	self.font:draw(width, height)
end

return game
