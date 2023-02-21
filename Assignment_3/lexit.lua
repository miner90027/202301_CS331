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
    if s:len() ~= 1 then
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

    local position       -- Index of the next char in the program
                        --      ...
    local state         -- Current state of the state machine
    local ch            -- Current character
    local lexStr        -- The current lexeme
    local cat           -- Category of lexeme, state when set to _Done
    local hand          -- Disbatch table of State-Handler functions
    local keywords      -- An Array of keywords as defined in Maleo Lexeme spec
    
    keywords = {"and", "char", "cr", "do","else", "elseif","end","false","function",
        "if","not","or","rand","read","return","then","true","while","write"}

    -- checkKey()
    -- Used to check if the given string is contained in the table of keywords
    --      returns true if a match is found, otherwise returns false
    local function checkKey(str)
       for index, value in pairs(keywords) do
            if value == str then
                return true
            end
       end
       return false
    end
            
    --[[***********************************]]--
    --[[***           States            ***]]--
    --[[***********************************]]--

    local _Done = 0
    local _Start = 1
    local _Alpha = 2
    

    --[[***********************************]]--
    --[[*** Character Utility Functions ***]]--
    --[[***********************************]]--


    -- curChar()
    -- Return the current character at index position in the current program
    --      value will be either a single character string or an empty string.
    local function curChar()
        return program:sub(position, position)
    end


    -- nxtChar()
    -- Return the next character at index position+1 in the current program
    --      value will be either a single character string or an empty string
    local function nxtChar()
        return program:sub(position+1, position+1)
    end
    
    
    -- nxtPos()
    -- Move the position to the next character.
    local function nxtPos()
        position = position + 1
    end

    -- addLex()
    -- Add the current character to the lexeme, moving the position to the next
    -- character.
    local function addLex()
        lexStr = lexStr .. curChar()
        nxtPos()
    end

    -- nxtLex()
    -- Skip whitespace and comments, moving the position to the beginning of the 
    --      next lexeme or to the end of the program length
    local function nxtLex()
        while true do
            -- skip all whitespace characters
            while isBlank(curChar()) do
                nxtPos()
            end
            
            -- Done if there are no comments
            if curChar() ~= "-" and nxtChar() ~= "-" or curChar() ~= "#" and curChar() ~= "!" then
                break
            end 

            nxtPos() -- drop leading - or #
            nxtPos() -- drop leading - or !

            while true do
                if curChar() == "\n" then
                    nxtPos() -- drop tailing new line character
                    break
                elseif curChar() == "" then
                    return
                end

                nxtPos() -- drop the character inside the comment
            end            
        end
    end
    
    --[[***********************************]]--
    --[[***   State-Handler Functions   ***]]--
    --[[***********************************]]--

    -- state _Done: lexeme is complete; this handler should not be called
    local function hand_Done()
        error("'_Done' state should not be handled\n")
    end

    local function hand_Start()
        if isIllegal(ch) then
            addLex()
            state = _Done
            cat = lexit.MAL
        elseif isAlpha(ch) then
            addLex()
            state = _Alpha
        else
            addLex()
            state = _Done
            cat = lexit.PUNCT
        end
    end

    -- State _Alpha: we are in an Identifier
    local function hand_Alpha()
        if isAlpha(ch) or isNum(ch) or ch == "_" then
            addLex()
        else
            state = _Done
            if checkKey(lexStr) then
                cat = lexit.KEY
            else
                cat = lexit.ID
            end
        end
    end
    
    -- Table of State-Handler Functions

    hand = {
        [_Done] = hand_Done,
        [_Start] = hand_Start,
        [_Alpha] = hand_Alpha
    }
    
    --[[***********************************]]--
    --[[***       Iterator Function     ***]]--
    --[[***********************************]]--

    local function getLex(dummy1, dummy2)
        if position > program:len() then
            return nil, nil
        end

        lexStr = ""
        state = _Start

        while state ~= _Done do
            ch = curChar()
            hand[state]()
        end
        nxtLex()
        return lexStr, cat
    end

    --[[***********************************]]--
    --[[***        Body of lex          ***]]--
    --[[***********************************]]--

    position = 1
    nxtLex()
    return getLex, nil, nil
end

-- return module table
return lexit
