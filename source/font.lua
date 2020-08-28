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
	return setmetatable({
		image = image,
		quads = quads,
		canvas = love.graphics.newCanvas(width*(fontWidth+1), height*(fontHeight+1)),
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

return font
