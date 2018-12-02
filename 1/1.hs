import qualified Data.IntSet as S

partOne :: [String] -> Int
partOne xs = foldl (\acc x -> acc + myRead x) 0 xs

myRead :: String -> Int
myRead (x:xs) = if x == '+'
                then read xs :: Int
                else read (x:xs) :: Int

readInBulk :: String -> [Int]
readInBulk x = map (myRead) (words x)


partTwo :: String -> Int
partTwo = go S.empty . scanl (+) 0 . cycle . readInBulk
    where go s (x:xs)
              | x `S.member` s = x
              | otherwise = go (S.insert x s) xs

main = do
    input <- readFile "input.txt"
    print (partOne (words input))
    print (partTwo input)
    
