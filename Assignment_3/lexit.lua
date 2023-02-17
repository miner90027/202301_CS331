#!/usr/bin/env lua

--[[
  - lexit.lua
  - Aleks McCormick
  - 2023/02/15
  - Spring 2023 CS 331
  - Assignment 3
  -     Lexer for instrucor created Maleo language
--]]

--[[***          Section A          ***]]--

	-- Secret Message: I am one with the Forth. The Forth is with me.

--[[***          Section B          ***]]--


-- Initilize module table
local lexit = {}

--[[***********************************]]--
--[[***      Public Constants       ***]]--
--[[***********************************]]--

-- Numeric constants representing the different lexeme categories
lexit.KEY    = 1
lexit.ID     = 2
lexit.NUMLIT = 3
lexit.STRLIT = 4
lexit.OP     = 5
lexit.PUNCT  = 6
lexit.MAL    = 7

-- catnames
-- Array of human-readable lexeme categories in strings. The 
--      indacies of the categories match the above numeric constants.
lexit.catnames = {
    "Keyword",
    "Identifier",
    "NumericLiteral",
    "StringLiteral",
    "Operator",
    "Punctuation",
    "Malformed"
}



--[[***********************************]]--
--[[***  Character Type Functions   ***]]--
--[[***********************************]]--


-- isAlpha
-- Returns true if the character is a letter, otherwise return false
local function isAlpha(s)
    return false
end

-- isNum
-- Returns true if the character is a number, otherwise return false
local function isNum(s)
    return false
end

-- isBlank
-- Returns true if the character is whitespace, otherwise return false
local function isBlank(s)
    return false
end

-- isAscii
-- Returns true if the character is a printable ASCII, otherwise return false
local function isAscii(s)
    return false
end

-- isIllegal
-- Returns true if the character is an illegal caracter, otherwise return false
local function isIllegal(s)
    return false
end



--[[***********************************]]--
--[[***            Lexer            ***]]--
--[[***********************************]]--

-- lex
-- Lexer Description
function lexit.lex(program)

    

    return nil, nil, nil
end

-- return module table
return lexit
