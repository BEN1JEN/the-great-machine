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
	}, {__index=gui})
end

return gui
