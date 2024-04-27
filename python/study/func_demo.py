def outer():
    num = 10
    print(num)

    def inner():
        nonlocal num
        num = 21
        print(num)

    inner()
    print(num)


outer()
