{- findmax.hs
 - Aleks McCormick
 - 2023/03/29
 - Spring 2023 CS 331
 - Assignment 5
 -     Part A & C
 - Interactive program for finding the max input
-}

{-*********************************************-}
{-***                Part A                 ***-}
{-*********************************************-}

-- Secret Message: "Every earless elephant eagerly eats endive early each evening."


{-*********************************************-}
{-***                Part C                 ***-}
{-*********************************************-}


module Main where

import System.IO


main = do
    putStrLn ""
    putStrLn "Please enter a list of integers, one per line."
    putStrLn "I will calculate the maximum item in the provided list."
    putStrLn ""

    list <- vals

    if null list then 
        putStrLn "Empty list - no maximum."
    else do
        let max = maximum list
    
        putStr "The maximum value is: "
        putStrLn $ show max        
        
    continue
            
    return ()



    
continue = do
    putStrLn ""
    putStrLn "Would you like to compute another maximum? (y/n) "
    hFlush stdout

    choice <- getLine

    if choice == "y" || choice == "Y" then do
        main
    else if choice == "n" || choice == "N" then do
        putStrLn "Bye!" 
        return ()
    else 
        continue

        

vals = do
        
    putStr "Please input an integer or a blank line to finish: "
    hFlush stdout

    input <- getLine
    if input == "" then
        return []
    else do
        let n = read input :: Int
        rest <- vals
        return (n : rest) 
