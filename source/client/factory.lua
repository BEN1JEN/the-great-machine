local chars = require("chars")
local factory = {}

function factory:new()
	return setmetatable({
		grid = {tiles={}, width=0, height=0},
		camera = {x=-2, y=-2},
	}, {__index=factory})
end

local function drawMachine(font, x, y, machine)
	local baseChar = chars.machines[machine]:byte()
	font:render(string.char(baseChar+0x00, baseChar+0x01, 10, baseChar+0x10, baseChar+0x11), x, y)
end

function factory:draw(font, ox, oy, width, height)
	font:box(chars.beam, ox, oy, width, height, "Factory Floor")
	font:render((chars.factory.wall:rep(width) .. "\n"):rep(height), ox, oy)
	local floorX, floorY, floorWidth, floorHeight = ox-self.camera.x*2, oy-self.camera.y*2, self.grid.width*2, self.grid.height*2
	font:render((chars.factory.floor:rep(floorWidth) .. "\n"):rep(floorHeight), floorX, floorY)
	font:box(chars.walls, floorX, floorY, floorWidth, floorHeight)
	for x, column in pairs(self.grid.tiles) do
		for y, tile in pairs(column) do
			drawMachine(font, x-self.camera.x*2-1, y-self.camera.y*2-1, tile.type)
		end
	end
end

return factory
