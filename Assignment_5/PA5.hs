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
-- Takes a list of integer values and returns a list of the 
--      number of times collatz is called to reduce the respective
--      input values to 0.
collatzCounts :: [Integer]
collatzCounts = map counter [1..] where
    counter n = count n 0 where
        count 1 x = x
        count n x = count (collatz n) (x + 1)
    collatz x
        | x == 0         = 0
        | mod x 2 == 0   = div x 2 
        | otherwise      = x * 3 + 1 

-- =====================================================================


-- findList
-- Takes two lists of the same type and returns a Maybe Int. If the first
--      list is found as a contiguous sublist of the second list, then the
--      return value is Just n, where n is the starting index of the sublist.
--      If the first list is not found as a continguous sublist of the second,
--      then the return value is Nothing.
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
-- Takes two opperands of the same type. Returns an int giving the total
--      number of indices which both lists contain equal values.
(##) :: Eq a => [a] -> [a] -> Int
listA ## listB = length match where
    match = filter (\i -> listA !! i == listB !! i) [0.. (length listA -1)]


-- =====================================================================


-- filterAB
-- Takes a boolean function and two lists. It returns a list of items
--      in the second list for which the corresponding item in the first
--      list makes the boolean function true.
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ _ [] = []
filterAB _ [] _ = []
filterAB func (x:xs) (y:ys)
    | func x = y : filterAB func xs ys
    | otherwise = filterAB func xs ys


-- =====================================================================


-- concatEvenOdd
-- Takes a list of strings and returns a tuple of two strings, the concactination
--      of all the even-index items and a concactination of all the odd-index items.
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

