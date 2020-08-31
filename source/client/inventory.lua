local items = require "client.items"
local chars = require "chars"
local inventory = {}

function inventory.draw(font, data, x, y, width, height, mouseX, mouseY)
	local str = ""
	for y = 1, height do
		for x = 1, width do
			local item, itemStr = data.slots[x][y]
			if item.amount == 0 then
				itemStr = " "
			else
				itemStr = chars.items[items[item.type].char] or "?"
			end
			str = str .. itemStr .. chars.beam.upDown
		end
		str = str .. "\n" .. chars.beam.leftRight:rep(width*2) .. "\n"
	end
	font:render(str, x, y)
	local invMouseX, invMouseY = math.floor(mouseX-x)/2+1, math.floor(mouseY-y)/2+1
	if invMouseX > 0 and invMouseX <= width and invMouseY > 0 and invMouseY <= height and math.isInteger(invMouseX) and math.isInteger(invMouseY) then
		local item = data.slots[invMouseX][invMouseY]
		if item.amount > 0 then
			local tooltip = tostring(item.type) .. "\n" .. tostring(item.amount)
			local tooltipWidth, tooltipHeight = 0, 2
			local tooltipBox = ""
			for line in tooltip:gmatch("[^\n\r]+") do
				tooltipWidth = math.max(tooltipWidth, #line)
				tooltipHeight = tooltipHeight + 1
			end
			for line in tooltip:gmatch("[^\n\r]+") do
				tooltipBox = tooltipBox .. chars.beam.upDown .. line .. (" "):rep(tooltipWidth-#line) .. chars.beam.upDown .. "\n"
			end
			tooltipBox = chars.beam.downRight .. chars.beam.leftRight:rep(tooltipWidth) .. chars.beam.downLeft .. "\n" .. tooltipBox
			tooltipBox = tooltipBox .. chars.beam.upRight .. chars.beam.leftRight:rep(tooltipWidth) .. chars.beam.upLeft
			tooltipWidth = tooltipWidth + 2

			font:render(tooltipBox, math.floor(mouseX)-tooltipWidth, math.floor(mouseY)-tooltipHeight)
		end
	end
end

function inventory.moveItem(machineX, machineY, machineInv, machineSlotX, machineSlotY, playerSlotX, playerSlotY, game)
	game.host:send(serialize.serialize{
		type="moveItem",
		machinePos={x=machineX, y=machineY},
		machineInventoryId=machineInv,
		machineSlot={x=machineSlotX, y=machineSlotY},
		playerSlot={x=playerSlotX, y=playerSlotY},
	})
end

return inventory
