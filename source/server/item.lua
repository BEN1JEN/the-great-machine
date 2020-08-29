local item = {items={}}

function item.init()
	for _, file in ipairs(love.filesystem.getDirectoryItems("assets/items")) do
		local items = dofile("assets/items/" .. file)
		for name, i in pairs(items) do
			item.items[name] = i
		end
	end
end

function item.new(type)
	if not item.items[type] then
		error("No item found: " .. tostring(type))
	end

end

function item.mine()
	local resources = {}
	for type, i in pairs(item.items) do
		if i.rarity then
			while math.random(1, i.rarity) == 1 do
				table.insert(resources, item.new(type))
			end
		end
	end
	return resources
end

item.init()

return item
