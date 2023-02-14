#!/usr/bin/env lua

--[[
  - pa2.lua
  - Aleks McCormick
  - 2023/02/13
  - Spring 2023 CS 331
  - Assignment 2 Lua module
--]]

--[[***          Section A          ***]]--

	-- Secret Message: Be VERY sure to drink you Ovaltine.

--[[***          Section B          ***]]--

-- Module table 
local pa2 = {} 


--[[***********************************]]--
--[[***      Exported Functions     ***]]--
--[[***********************************]]--

-- mapTable
-- Takes in a one-paraperter function and a table. Returns a new table of key-value pairs
--   	for each key-value pair in the provided table
-- Exported
function pa2.mapTable(func, tbl)
    
    local output = {}
        
    for key, val in pairs(tbl) do
       output[key] = func(val)
       -- table.insert(output, [key]=func(val))
    end
    
	return output
end


-- concatMax
-- Takes a string and integer. Returns a sring concatanation of as many copies of the given
--   	string as possible without exceeding a lenght greater than the given integer.
-- Exported
function pa2.concatMax(str, max)

    local output = ""

    while(string.len(output) + string.len(str) <= max) do
        output = output..str
    end
    
	return output
end

-- collatz
-- An itterator function usable in Lua's for-in loop. Takes an integer parameter and it goes 
--  	through one or more integers. These are enteries in the collatz sequesnce starting at 
--  	the given integer.
-- Exported
function pa2.collatz(temp)
	return nil
end

-- backSubs
-- A coroutine that takes a single string as a parameter and yeilds all the substrings of the
--  	reverse of the given string starting at a zero length string, increasing in length until 
--  	it yeilds the full reverse of the given string.
-- Exported
function pa2.backSubs(temp)
	return nil
end


--[[***********************************]]--
--[[***   Non-Exported Functions    ***]]--
--[[***********************************]]--

-- All declarations after this point must be pre-fixed with "local"

-- Return the module, so it is usable by client code.
return pa2
