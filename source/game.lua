local serialize = require "serialize"
local game = {}

function game.new(address)
	local host = require("enet").host_create()
	host:connect(address)
	return setmetatable({
		font = require("font").new("assets/font.png", 80, 45),
		host = host,
		factory = require("client.factory").new(),
		openWindows = {},
	}, {__index=game})
end

function game:update(delta, input)
	local width, height = love.window.getMode()
	local mouseX, mouseY = self.font:getMouse(width, height)
	input.mouse = {x=mouseX, y=mouseY}
	self.factory:update(delta, input, self)
	for _, window in pairs(self.openWindows) do
		window:update(delta, input, self)
	end
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			local data = serialize.deserialize(event.data)
			print("receive packet", data)
			if data.type == "factoryGrid" then
				self.factory:load(data.grid)
			end
		elseif event.type == "connect" then
		elseif event.type == "disconnect" then
		end
		event = self.host:service()
	end
end

function game:openWindow(window)
	table.insert(self.openWindows, window)
end

function game:closeWindow(closingWindow)
	closingWindow:close()
	for id, window in pairs(self.openWindows) do
		if window == closingWindow then
			self.openWindows[id] = nil
		else
			window.redrawAll = true
		end
	end
	self.factory.redrawAll = true
end

function game:draw()
	local width, height = love.window.getMode()
	self.factory:draw(self.font, 1, 1, 78, 43)
	for _, window in pairs(self.openWindows) do
		window:draw(self.font)
	end
	self.font:draw(width, height)
end

return game
