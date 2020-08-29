local inventory = require "inventory"
local tile = {tiles={}}

function tile.init()
	for _, file in ipairs(love.filesystem.getDirectoryItems("assets/tiles")) do
		local t = dofile("assets/tiles/" .. file)
		tile.tiles[file:gsub("%.lua$", "")] = t
	end
end

function tile.new(tileType)
	local tileData = tile.tiles[tileType]
	if not tileData then
		error("No tile found: " .. tostring(tileType))
	end
	local newTile = {type=tileType}
	if tileData.inventory then
		newTile.inventory = {}
		for _, inv in ipairs(tileData.inventory) do
			table.insert(newTile.inventory, inventory.new(inv.width, inv.height))
		end
	end
	return newTile
end

function tile.mine()
	local resources = {}
	for type, i in pairs(tile.tiles) do
		if i.rarity then
			while math.random(1, i.rarity) == 1 do
				table.insert(resources, tile.new(type))
			end
		end
	end
	return resources
end

tile.init()

return tile
