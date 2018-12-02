import Data.List

containsTwo :: [Int] -> Bool
containsTwo x = elem 2 x

containsThree :: [Int] -> Bool
containsThree x = elem 3 x

groupSort :: String -> [Int]
groupSort x = map length (group $ sort x)

getTwos :: [String] -> Int
getTwos x = length (filter containsTwo (map groupSort x))

getThrees :: [String] -> Int
getThrees x = length (filter containsThree (map groupSort x))

partOne :: [String] -> Int
partOne x = (getTwos x) * (getThrees x)

main = do
    input <- readFile "input.txt"
    print (partOne (words input))