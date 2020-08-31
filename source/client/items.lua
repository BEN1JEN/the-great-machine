local items = {}

for _, file in ipairs(love.filesystem.getDirectoryItems("assets/items")) do
	local itemList = dofile("assets/items/" .. file)
	for name, i in pairs(itemList) do
		items[name] = i
	end
end

return items
