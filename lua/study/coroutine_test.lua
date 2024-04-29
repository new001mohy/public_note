local cor0
local cor1
local n = 0
local function print_0()
	while true do
		print(string.format("thread_0: %d", n))
		n = n + 1
		coroutine.yield()
	end
end

local function print_1()
	while true do
		if n > 100 then
			os.exit()
		end
		print(string.format("thread_1: %d", n))
		n = n + 1
		coroutine.yield()
	end
end

cor0 = coroutine.create(print_0)
cor1 = coroutine.create(print_1)

while true do
	if coroutine.status(cor0) == "suspended" then
		coroutine.resume(cor0)
	end
	if coroutine.status(cor1) == "suspended" then
		coroutine.resume(cor1)
	end
end
