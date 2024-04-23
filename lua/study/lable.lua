local a = 1

:: lable :: print("-- goto lable --")

a = a + 1

if a < 3 then
  goto lable
end


local i = 0
:: s1 :: do 
  print(i)
  i = 1 + i
end

if i > 3 then
  os.exit(1)
end
goto s1
