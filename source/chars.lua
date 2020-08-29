local chars = {
	beamUpDown = 0x80,
	beamLeftRight = 0x81,
	beamDownRight = 0x82,
	beamDownLeft = 0x83,
	beamUpRight = 0x84,
	beamUpLeft = 0x85,
	beamDownLeftRight = 0x86,
	beamUpDownLeft = 0x87,
	beamUpLeftRight = 0x88,
	beamUpDownRight = 0x89,
	beamAll = 0x8A,
	beamStartLabel = 0x8B,
	beamEndLabel = 0x8C,

	duelUpDown = 0x90,
	duelLeftRight = 0x91,
	duelDownRight = 0x92,
	duelDownLeft = 0x93,
	duelUpRight = 0x94,
	duelUpLeft = 0x95,
	duelDownLeftRight = 0x96,
	duelUpDownLeft = 0x97,
	duelUpLeftRight = 0x9,
	duelUpDownRight = 0x99,
	duelAll = 0x9A,
	duelStartLabel = 0x9B,
	duelEndLabel = 0x9C,
}

for name, char in pairs(chars) do
	chars[name] = string.char(char)
end

return chars
