local chars = require "chars"
local i18n = require "i18n"
local inventory = require "client.inventory"
local serialize = require "serialize"
local gui = {}
local opened = {}

function gui.tile(tile, machineX, machineY)
	if opened[tile.type] then
		return false
	end
	opened[tile.type] = true
	local tileData = require("assets.tiles." .. tostring(tile.type))
	if not tileData.gui then
		return false
	end
	return setmetatable({
		type = tile.type,
		layout = tileData,
		data = tile,
		title = "gui." .. tile.type,
		redrawAll = true,
		mouseX = 0, mouseY = 0,
		machineX = machineX, machineY = machineY,
	}, {__index=gui})
end

function gui.inventory(inventory, x, y, width, height)
	return setmetatable({
		type = "player",
		layout = {gui={x=x, y=y, width=width*2, height=height*2}, inventory={{x=0, y=0, width=width, height=height}}},
		data = {inventory={inventory}},
		title = "gui.playerInventory",
		redrawAll = true,
		mouseX = 0, mouseY = 0,
	}, {__index=gui})
end

function gui:update(delta, input, game)
	if input.interact.down and
		math.floor(input.mouse.x) == self.layout.gui.x+self.layout.gui.width-1 and
		math.floor(input.mouse.y) == self.layout.gui.y-1 then
		game:closeWindow(self)
	end
	self.mouseX, self.mouseY = input.mouse.x, input.mouse.y
	if self.layout.inventory and input.interact.down then
		for id, inv in ipairs(self.layout.inventory) do
			local invMouseX, invMouseY = math.floor(input.mouse.x-self.layout.gui.x+inv.x)/2+1, math.floor(input.mouse.y-self.layout.gui.y+inv.y)/2+1
			if invMouseX > 0 and invMouseX <= inv.width and invMouseY > 0 and invMouseY <= inv.height and math.isInteger(invMouseX) and math.isInteger(invMouseY) then
				if self.type == "player" then
					inventory.swapPlayerItem(invMouseX, invMouseY, game)
				else
					inventory.swapMachineItem(self.machineX, self.machineY, id, invMouseX, invMouseY, game)
				end
			end
		end
	end
end

function gui:draw(font)
	self.redrawAll = true -- TODO: Don't be lazy
	if self.redrawAll then
		self:drawAll(font)
		self.redrawAll = false
	end
end

function gui:close()
	opened[self.type] = false
end

function gui:drawAll(font)
	font:box(chars.duel, self.layout.gui.x, self.layout.gui.y, self.layout.gui.width, self.layout.gui.height, i18n(self.title))
	font:fill(" ", self.layout.gui.x, self.layout.gui.y, self.layout.gui.width, self.layout.gui.height)
	font:render("X", self.layout.gui.x+self.layout.gui.width-1, self.layout.gui.y-1)
	if self.layout.inventory then
		for id, inv in ipairs(self.layout.inventory) do
			inventory.draw(font, self.data.inventory[id], self.layout.gui.x+inv.x, self.layout.gui.y+inv.y, inv.width, inv.height, self.mouseX, self.mouseY)
		end
	end
end

return gui
