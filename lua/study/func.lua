function _ADD(...)
	print("总共传入" .. select("#", ...) .. " 个数")
	local s = 0
	for _, value in ipairs({ ... }) do
		s = s + value
	end
	return s
end

print(_ADD(1, 2, 3, 34, 5, 6))
