partOne :: [String] -> Integer
solution xs = foldl (\acc x -> acc + myRead x) 0 xs

myRead :: String -> Integer
myRead (x:xs) = if x == '+'
                then read xs :: Integer
                else read (x:xs) :: Integer

main = do
    input <- readFile "input.txt"
    print (partOne (words input))
    
