-- PA5.hs
-- Finished by:
-- Aleks McCormick
-- 2023\03\27 
--
-- Started by:
-- Glenn G. Chappell
-- 2023-03-22
--
-- For CS 331 Spring 2023
-- Solutions to Assignment 5 Exercise B

module PA5 where


-- =====================================================================


-- collatzCounts
collatzCounts :: [Integer]
collatzCounts = map counter [1..] where
    counter n = count n 0 where
        count 1 x = x
        count n x = count (collatz n) (x + 1)
    collatz x
        | x == 0         = 0
        | mod x 2 == 0   = x `div` 2 
        | otherwise      = x * 3 + 1 

-- =====================================================================


-- findList
findList :: Eq a => [a] -> [a] -> Maybe Int
findList listA listB
    | null listA = Just 0
    | fst ( index listA listB 0) = Just (snd (index listA listB 0))
    | otherwise = Nothing
    where
        index listA listB i
            | listA == take (length listA) listB = (True, i)
            | null listB = (False, i)
            | otherwise = index listA (drop 1 listB) (i + 1)


-- =====================================================================


-- operator ##
(##) :: Eq a => [a] -> [a] -> Int
listA ## listB = length match where
    match = filter (\i -> listA !! i == listB !! i) [0.. (length listA -1)]


-- =====================================================================


-- filterAB
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ _ [] = []
filterAB _ [] _ = []
filterAB func (x:xs) (y:ys)
    | func x = y : filterAB func xs ys
    | otherwise = filterAB func xs ys


-- =====================================================================


-- concatEvenOdd
concatEvenOdd :: [String] -> (String, String)
{-
  The assignment requires concatEvenOdd to be written as a fold.
  Like this:

    concatEvenOdd xs = fold* ... xs  where
        ...

  Above, "..." should be replaced by other code. "fold*" must be one of
  the following: foldl, foldr, foldl1, foldr1.
-}
concatEvenOdd listA = (foldl1 (++) (even listA), foldl1 (++) (odd listA)) where
    odd [] = []
    odd (_:xs) = even xs
    even [] = []
    even (x:xs) = x:odd xs 

