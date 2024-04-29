def countdown(n):
    while n > 0:
        yield n
        n -= 1


# 创建生成器对象

generator = countdown(5)

print(next(generator))

for i in generator:
    print(i)
