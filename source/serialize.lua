local serialize = {}

function serialize.serialize(data)
	if type(data) == "table" then
		local str = "["
		for k, v in pairs(data) do
			str = str .. serialize.serialize(k) .. "=" .. serialize.serialize(v) .. ","
		end
		str = str .. "]"
		return str
	elseif type(data) == "number" or type(data) == "bool" or type(data) == "nil" then
		return tostring(data)
	else
		return "\"" .. tostring(data) .. "\""
	end
end

function serialize.deserialize(str)
	if str:sub(1, 1) == "[" then
		local tab, i = {}, 2
		while i < #str and str:sub(i, i) ~= "]" do
			local key, endLoc = serialize.deserialize(str:sub(i, -1))
			i = i + endLoc + 1
			local value, endLoc = serialize.deserialize(str:sub(i, -1))
			i = i + endLoc + 1
			tab[key] = value
		end
		return tab, i
	elseif str:sub(1, 1) == "\"" then
		local _, endLoc = str:find("\".-\"")
		return str:sub(2, endLoc-1), endLoc
	elseif str:sub(1, 4) == "true" then
		return true, 5
	elseif str:sub(1, 5) == "false" then
		return false, 6
	elseif str:sub(1, 3) == "nil" then
		return nil, 4
	else
		local _, endLoc = str:find("[0-9]*%.?[0-9]*")
		return tonumber(str:sub(1, endLoc)), endLoc
	end
end

return serialize
