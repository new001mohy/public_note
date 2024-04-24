-- 父类
Phone = { price = 0, name = "", brand = "" }

-- 父类构造函数

function Phone:new(o, price, name, brand)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	price = price or 0
	name = name or ""
	brand = brand or ""
	return o
end

-- 父类方法
function Phone.call()
	print("call ...")
end

-- 父类对象
base_class = Phone:new(nil, 1299, "redme", "Xiaomi")
-- 未重写方法，调用父类的call方法
base_class:call()

-- 子类
Xiaomi = Phone:new()

-- 子类构造函数
function Xiaomi:new(o, price, name, brand)
	o = o or Phone:new(o, price, name, brand)
	setmetatable(o, self)
	self.__index = self
	return o
end

-- 子类方法
function Xiaomi:call()
	print("Xiaomi call ...")
end

xiaomi = Xiaomi:new(nil, 4599, "xiaomi-14", "xiaomi")

xiaomi:call()
