local chars = require "chars"
local i18n = require "i18n"
local gui = {}

function gui.tile(tile)
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

end

function gui:draw(font)
	if self.redrawAll then
		self:drawAll(font)
		self.redrawAll = false
	end
end

function gui:drawAll(font)
	font:box(chars.duel, self.layout.gui.x, self.layout.gui.y, self.layout.gui.width, self.layout.gui.height, i18n(self.title))
	font:fill(" ", self.layout.gui.x, self.layout.gui.y, self.layout.gui.width, self.layout.gui.height)
end

return gui
