local serialize = require "serialize"
local gui = require "gui"
local game = {}

function game.new(address)
	local host = require("enet").host_create()
	local server = host:connect(address)
	return setmetatable({
		font = require("font").new("assets/font.png", 80, 45),
		host = host,
		server = server,
		factory = require("client.factory").new(),
		playerInventory = require("server.inventory").new(12, 6),
		playerGui = nil,
		openWindows = {},
		heldSlot = {amount=0},
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
	if input.inventory.down then
		if self.playerGui then
			self:closeWindow(self.playerGui)
		else
			self.playerGui = gui.inventory(self.playerInventory, 80/2-12*2/2, 44-6*4-4, 12, 6)
			self:openWindow(self.playerGui)
		end
	end
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			local data = serialize.deserialize(event.data)
			if data.type == "factoryGrid" then
				self.factory:load(data.grid)
			elseif data.type == "setHeldSlot" then
				self.heldSlot = data.slot
			elseif data.type == "setMachineSlot" then
				self.factory.grid.tiles[data.machinePos.x][data.machinePos.y].inventory[data.machineInventoryId].slots[data.machineSlot.x][data.machineSlot.y] = data.slot
			elseif data.type == "setPlayerSlot" then
				self.playerInventory.slots[data.playerSlot.x][data.playerSlot.y] = data.slot
			elseif data.type == "error" then
				print("Server error: " .. tostring(data.error))
			else
				print("Unknown packet:", data)
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
	if closingWindow == self.playerGui then
		self.playerGui = nil
	end
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
