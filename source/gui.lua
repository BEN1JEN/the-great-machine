local chars = require "chars"
local i18n = require "i18n"
local gui = {}
local opened = {}

function gui.tile(tile)
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
	}, {__index=gui})
end

function gui:update(delta, input, game)
	if input.interact.down and
		math.floor(input.mouse.x) == self.layout.gui.x+self.layout.gui.width-1 and
		math.floor(input.mouse.y) == self.layout.gui.y-1 then
		game:closeWindow(self)
	end
end

function gui:draw(font)
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
		for _, inv in ipairs(self.layout.inventory) do
		end
	end
end

return gui
