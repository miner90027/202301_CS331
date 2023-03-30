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


-- WARNING:
-- The following code will only accept integer type values when prompting for integers.
-- Use of non-integer values when inputing the list of values causes the program to crash
--      when calculating the maximum value.

module Main where

import System.IO



-- main
-- Main program. Prompts user for input and provides output
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



-- continue
-- Provides user with the choice to continue entering new lists
-- Accepts following characters as input: y Y n N
--      If provided invalid input, then it just prompts again.
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



-- vals
-- Prompts and takes user input for integers. Will accept but
--      cannot handle non-integer input. Non-integer input 
--      causes program to crash after main calls this IO block. 
-- Continues prompting until the user inputs a blank line.
-- Returns a list of the input values.
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
