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
https://raw.githubusercontent.com/ggchappell/cs331-2023-01/main/lexit_test.lualexit.KEY    = 1
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

-- All of the Character-Type functions return false if the string size
--      is anything other than a single character.

-- isAlpha
-- Returns true if the character is a letter, otherwise return false
local function isAlpha(s)
    if s:len() ~= 1 then
        return false
    elseif s >= "A" and s <= "Z" then
        return true
    elseif s >= "a" and s <= "z" then
        return true
    else
        return false
    end
end

-- isNum
-- Returns true if the character is a number, otherwise return false
local function isNum(s)
    if c:len() ~= 1 then
        return false
    elseif s >= "0" and s <= "9" then
        return true
    else
        return false
    end
end

-- isBlank
-- Returns true if the character is whitespace, otherwise return false
local function isBlank(s)
    if s:len() ~= 1 then 
        return false
    elseif s == " " or s == "\t" or s == "\n" or s == "\r" or s == "\f" then
        return true
    else
        return false
    end
end

-- isAscii
-- Returns true if the character is a printable ASCII, otherwise return false
local function isAscii(s)
    if s:len() ~= 1 then
        return false
    elseif s >= " " and s <= "~" then
        return true
    else
        return false
    end
end

-- isIllegal
-- Returns true if the character is an illegal caracter, otherwise return false
local function isIllegal(s)
    if s:len() ~= 1 then 
        return false
    elseif isBlank(s) or isAscii(s) then
        return false
    else
        return false
    end
end



--[[***********************************]]--
--[[***            Lexer            ***]]--
--[[***********************************]]--

-- lex
-- Lexer Description
function lexit.lex(program)

    --[[***********************************]]--
    --[[***         Variables           ***]]--
    --[[***********************************]]--

    local positon       -- Index of the next char in the program
                        --      ...
    local state         -- Current state of the state machine
    local ch            -- Current character
    local lexStr        -- The current lexeme
    local cat           -- Category of lexeme, state when set to _Done
    local hand          -- Disbatch table of State-Handler functions


    --[[***********************************]]--
    --[[***           States            ***]]--
    --[[***********************************]]--



    --[[***********************************]]--
    --[[*** Character Utility Functions ***]]--
    --[[***********************************]]--


    --[[***********************************]]--
    --[[***   State-Handler Functions   ***]]--
    --[[***********************************]]--


    
    --[[***********************************]]--
    --[[***       Iterator Function     ***]]--
    --[[***********************************]]--

    local function getLex(dummy1, dummy2)
        if positon > program:len() then
            return nil, nil
        end

        lexStr = ""
        state = _Start

        while state ~= _Done do
            --ch = --curChar()
            hand[state]()
        end

        --nextLex()
        return lexStr, cat
    end

    --[[***********************************]]--
    --[[***        Body of lex          ***]]--
    --[[***********************************]]--

    
    --nextLex()
    return getLex, nil, nil
end

-- return module table
return lexit
