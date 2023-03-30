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
findList _ _ = Just 42  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- operator ##
(##) :: Eq a => [a] -> [a] -> Int
_ ## _ = 42  -- DUMMY; REWRITE THIS!!!


-- =====================================================================


-- filterAB
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ _ bs = bs  -- DUMMY; REWRITE THIS!!!


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
concatEvenOdd _ = ("Yo", "Yoyo")  -- DUMMY; REWRITE THIS!!!

