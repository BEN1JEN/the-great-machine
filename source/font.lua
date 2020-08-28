local font = {}

function font.new(file, width, height)
	local image = love.graphics.newImage(file)
	image:setFilter("nearest", "nearest")
	local fontWidth, fontHeight = image:getWidth()/16, image:getHeight()/16
	local quads = {}
	for i = 0, 255 do
		local x, y = i%16, math.floor(i/16)
		quads[i] = love.graphics.newQuad(x*fontWidth, y*fontHeight, fontWidth, fontHeight, image:getWidth(), image:getHeight())
	end
	local canvas = love.graphics.newCanvas(width*(fontWidth+1), height*(fontHeight+1))
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
	local x, y = ox, oy
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
			love.graphics.draw(self.image, self.quads[text:sub(i, i):byte()], x*(self.fontWidth+1), y*(self.fontHeight+1))
			x = x + 1
		end
	end
	love.graphics.setCanvas()
end

function font:draw(targetWidth, targetHeight)
	local canvasWidth, canvasHeight = self.canvas:getWidth(), self.canvas:getHeight()
	local scaleX, scaleY = targetWidth/canvasWidth, targetHeight/canvasHeight
	local scale = math.min(scaleX, scaleY)
	local iScale = math.max(math.floor(scale), 1)
	local iCanvas = love.graphics.newCanvas(canvasWidth*iScale, canvasHeight*iScale)
	iCanvas:setFilter("linear", "linear")
	love.graphics.setCanvas(iCanvas)
	love.graphics.rectangle("fill", 0, 0, canvasWidth*iScale, canvasHeight*iScale)
	love.graphics.draw(self.canvas, 0, 0, 0, iScale, iScale)
	love.graphics.setCanvas()
	local offsetX, offsetY = (scaleX-scale)*canvasWidth/2, (scaleY-scale)*canvasHeight/2
	love.graphics.draw(iCanvas, offsetX, offsetY, 0, scale/iScale, scale/iScale)
	iCanvas:release()
end

return font
