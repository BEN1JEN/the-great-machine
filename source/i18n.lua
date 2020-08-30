local i18n = {selected="null", langs={null={}}}

function i18n.init(lang)
	i18n.langs[lang] = require("assets.lang." .. tostring(lang))
	i18n.selected = lang
end

function i18n.translate(key, ...)
	local rawtext = i18n.langs[i18n.selected][key]
	if not rawtext then
		local str = ""
		for i, v in ipairs{...} do
			if i ~= 1 then
				str = str .. ", "
			end
			str = str .. tostring(v)
		end
		return key .. "[" .. str .. "]"
	end
	return string.format(rawtext, ...)
end

return setmetatable(i18n, {__call=function(_, ...)return i18n.translate(...)end})
