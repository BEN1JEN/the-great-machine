local serialize = require "serialize"
local game = {}

function game.new(address)
	local host = require("enet").host_create()
	host:connect(address)
	return setmetatable({
		font = require("font").new("assets/font.png", 80, 45),
		host = host,
		factory = require("client.factory").new()
	}, {__index=game})
end

function game:update(delta, input)
	self.factory:update(delta, input)
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			local data = serialize.deserialize(event.data)
			if data.type == "factoryGrid" then
				self.factory.grid = data.grid
				self.factory.redrawAll = true
			end
		elseif event.type == "connect" then
		elseif event.type == "disconnect" then
		end
		event = self.host:service()
	end
end

function game:draw()
	local width, height = love.window.getMode()
	self.factory:draw(self.font, 1, 1, 78, 43)
	self.font:draw(width, height)
end

return game
