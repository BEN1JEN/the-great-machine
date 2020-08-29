local inventory = {}

function inventory.new(width, height)
	local slots = {}
	for x = 1, width do
		slots[x] = {}
		for y = 1, height do
			slots[x][y] = {amount=0}
		end
	end
	return setmetatable({
		slots = slots,
	}, {__index=inventory})
end

return inventory
