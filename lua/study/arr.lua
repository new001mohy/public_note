local myArr = { 12, 54, 45, 67, 90 }

for i = 1, #myArr, 1 do
	print(myArr[i])
end

for i = -2, 10, 1 do
	myArr[i] = i
end

for i = -2, 10, 1 do
	print(myArr[i])
end

function square(m, n)
	if n < m then
		n = n + 1
		return n, n * n
	end
end

for i, n in square, 3, 0 do
	print(i, n)
end

local array = { "google", "linux" }

function elementInterator(collection)
	local index = 0
	local count = #collection
	-- 闭包函数
	return function()
		index = index + 1
		if index <= count then
			return collection[index]
		end
	end
end

for element in elementInterator(array) do
	print(element)
end
