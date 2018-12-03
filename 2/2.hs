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

diffCount :: String -> String -> Int
diffCount (x:[]) (y:[]) = if x == y then 0 else 1
diffCount (x:xs) (y:ys) = if x == y then 0 + (diffCount xs ys) else 1 + (diffCount xs ys)

oneDiffed :: String -> String -> Bool
oneDiffed x y = diffCount x y == 1

oneDiffedOnes :: [String] -> (String, String)
oneDiffedOnes list = [(x, y) | x <- list, y <- list, oneDiffed x y]!!0

getCommons :: (String, String) -> String
getCommons (x:[], y:[]) = if x == y then [x] else []
getCommons (x:xs, y:ys) = if x == y then x:(getCommons (xs, ys)) else getCommons (xs, ys)

partTwo :: [String] -> String
partTwo x = getCommons (oneDiffedOnes x)

main = do
    input <- readFile "input.txt"
    print (partOne (words input))
    print (partTwo (words input))