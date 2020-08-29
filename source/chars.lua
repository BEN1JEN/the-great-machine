local chars = {
	beam = {
		upDown = 0x80,
		leftRight = 0x81,
		downRight = 0x82,
		downLeft = 0x83,
		upRight = 0x84,
		upLeft = 0x85,
		downLeftRight = 0x86,
		upDownLeft = 0x87,
		upLeftRight = 0x88,
		upDownRight = 0x89,
		all = 0x8A,
		startLabel = 0x8B,
		endLabel = 0x8C,
	},

	duel = {
		upDown = 0x90,
		leftRight = 0x91,
		downRight = 0x92,
		downLeft = 0x93,
		upRight = 0x94,
		upLeft = 0x95,
		downLeftRight = 0x96,
		upDownLeft = 0x97,
		upLeftRight = 0x9,
		upDownRight = 0x99,
		all = 0x9A,
		startLabel = 0x9B,
		endLabel = 0x9C,
	},

	factory = {
		floor = 0x9D,
		wall = 0x8D,
	},

	walls = {
		all = 0x8D,
		left = 0x8E,
		up = 0x8F,
		right = 0x9E,
		down = 0x9F,
		upLeft = 0xB1,
		upRight = 0xB0,
		downLeft = 0xA1,
		downRight = 0xA0,
	},

	machines = {
		chest = 0xA2,
	},
}

for catname, cat in pairs(chars) do
	for name, char in pairs(cat) do
		chars[catname][name] = string.char(char)
	end
end

return chars
