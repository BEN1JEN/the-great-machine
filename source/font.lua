local font = {}
font.cursor = love.graphics.newImage("assets/cursor.png")
font.cursor:setFilter("nearest", "nearest")

function font.new(file, width, height)
	local image = love.graphics.newImage(file)
	image:setFilter("nearest", "nearest")
	local fontWidth, fontHeight = image:getWidth()/16, image:getHeight()/16
	local quads = {}
	for i = 0, 255 do
		local x, y = i%16, math.floor(i/16)
		quads[i] = love.graphics.newQuad(x*fontWidth, y*fontHeight, fontWidth, fontHeight, image:getWidth(), image:getHeight())
	end
	local canvas = love.graphics.newCanvas(width*fontWidth, height*fontHeight)
	canvas:setFilter("nearest", "nearest")
	return setmetatable({
		image = image,
		quads = quads,
		canvas = canvas,
		fontWidth = fontWidth,
		fontHeight = fontHeight,
	}, {__index=font})
end

function font:render(text, ox, oy)
	local x, y = math.floor(ox), math.floor(oy)
	love.graphics.setCanvas(self.canvas)
	for i = 1, #text do
		if text:sub(i, i) == "\n" then
			x = ox
			y = y + 1
		elseif text:sub(i, i) == "\t" then
			x = x + 4
		elseif text:sub(i, i) == "\v" then
			y = y + 1
		else
			love.graphics.draw(self.image, self.quads[text:sub(i, i):byte()], x*(self.fontWidth), y*(self.fontHeight))
			x = x + 1
		end
	end
	love.graphics.setCanvas()
end

function font:box(boxType, x, y, width, height, label)
	x, y = x-1, y-1
	width, height = width+2, height+2

	self:render(boxType.downRight .. (boxType.leftRight or boxType.up):rep(width-2) .. boxType.downLeft, x, y)
	self:render(boxType.upRight .. (boxType.leftRight or boxType.down):rep(width-2) .. boxType.upLeft, x, y+height-1)
	for i = y+1, y+height-2 do
		self:render(boxType.upDown or boxType.left, x, i)
		self:render(boxType.upDown or boxType.right, x+width-1, i)
	end
	if label then
		self:render(boxType.startLabel .. tostring(label) .. boxType.endLabel, x+1, y)
	end
end

function font:draw(targetWidth, targetHeight)
	local canvasWidth, canvasHeight = self.canvas:getWidth(), self.canvas:getHeight()
	local scaleX, scaleY = targetWidth/canvasWidth, targetHeight/canvasHeight
	local scale = math.min(scaleX, scaleY)
	local offsetX, offsetY = (scaleX-scale)*canvasWidth/2, (scaleY-scale)*canvasHeight/2
	local mouseX, mouseY = love.mouse.getPosition()
	mouseX, mouseY = (mouseX-offsetX)/scale/self.fontWidth, (mouseY-offsetY)/scale/self.fontHeight
	local iScale = math.max(math.floor(scale), 1)
	local iCanvas = love.graphics.newCanvas(canvasWidth*iScale, canvasHeight*iScale)
	iCanvas:setFilter("linear", "linear")
	love.graphics.setCanvas(iCanvas)
	love.graphics.draw(self.canvas, 0, 0, 0, iScale, iScale)
	love.mouse.setVisible(false)
	love.graphics.draw(self.cursor, math.floor(mouseX)*iScale*self.fontWidth, math.floor(mouseY)*iScale*self.fontHeight, 0, iScale, iScale)
	love.graphics.setCanvas()
	love.graphics.draw(iCanvas, offsetX, offsetY, 0, scale/iScale, scale/iScale)
	iCanvas:release()
end

return font
