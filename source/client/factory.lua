local chars = require("chars")
local factory = {}

function factory:new()
	return setmetatable({
		grid = {tiles={}, width=0, height=0},
		camera = {x=0, y=0},
		redrawAll = true,
	}, {__index=factory})
end

local function drawMachine(font, x, y, machine)
	local baseChar = chars.machines[machine]:byte()
	font:render(string.char(baseChar+0x00, baseChar+0x01, 10, baseChar+0x10, baseChar+0x11), x, y)
end

function factory:update(delta, input)
	if input.right.held then
		self.camera.x = self.camera.x + delta*10
		self.redrawAll = true
	end
	if input.left.held then
		self.camera.x = self.camera.x - delta*10
		self.redrawAll = true
	end
	if input.down.held then
		self.camera.y = self.camera.y + delta*10
		self.redrawAll = true
	end
	if input.up.held then
		self.camera.y = self.camera.y - delta*10
		self.redrawAll = true
	end
end

function factory:draw(font, ox, oy, width, height)
	if self.redrawAll then
		self:drawAll(font, ox, oy, width, height)
	end
end

function factory:drawAll(font, ox, oy, width, height)
	self.redrawAll = false
	font:render((chars.factory.wall:rep(width) .. "\n"):rep(height), ox, oy)
	local floorX, floorY, floorWidth, floorHeight = ox-math.floor(self.camera.x*2), oy-math.floor(self.camera.y*2), self.grid.width*2, self.grid.height*2
	font:render((chars.factory.floor:rep(floorWidth) .. "\n"):rep(floorHeight), floorX, floorY)
	font:box(chars.walls, floorX, floorY, floorWidth, floorHeight)
	for x, column in pairs(self.grid.tiles) do
		for y, tile in pairs(column) do
			drawMachine(font, x-math.floor(self.camera.x*2)-1, y-math.floor(self.camera.y*2)-1, tile.type)
		end
	end
	font:box(chars.beam, ox, oy, width, height, "Factory Floor")
end

return factory
