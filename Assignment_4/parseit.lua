--[[ 
   - parseit.lua
   - Started by: Glenn G. Chappell
   - 2023-02-22
   -
   - Finished by: Aleks McCormick
   - 2023/02/27
   - Spring 2023 CS 331
   - Solution to Assignment 4, Exercise A
   - Requires lexit.lua
--]]

local lexit = require "lexit"

-- Module Table Initialization
local parseit = {}  -- Our module

--[[*********************************************]]--
--[[***               Variables               ***]]--
--[[*********************************************]]--

-- For lexer iteration
local iter          -- Iterator returned by lexit.lex
local state         -- State for above iterator (maybe not used)
local lexer_out_s   -- Return value #1 from above iterator
local lexer_out_c   -- Return value #2 from above iterator

-- For current lexeme
local lexstr = ""   -- String form of current lexeme
local lexcat = 0    -- Category of current lexeme:
                    --  one of categories below, or 0 for past the end

--[[*********************************************]]--
--[[***      Symbolic Constangs for AST       ***]]--
--[[*********************************************]]--

local STMT_LIST    = 1
local WRITE_STMT   = 2
local FUNC_DEF     = 3
local IF_STMT      = 4
local WHILE_LOOP   = 5
local RETURN_STMT  = 6
local FUNC_CALL    = 7
local SIMPLE_VAR   = 8
local ARRAY_VAR    = 9
local ASSN_STMT    = 10
local STRLIT_OUT   = 11
local CR_OUT       = 12
local CHAR_CALL    = 13
local BIN_OP       = 14
local UN_OP        = 15
local NUMLIT_VAL   = 16
local BOOLLIT_VAL  = 17
local RAND_CALL    = 18
local READ_CALL    = 19

--[[*********************************************]]--
--[[***           Utility functions           ***]]--
--[[*********************************************]]--

-- advance
-- Go to next lexeme and load it into lexstr, lexcat.
-- Should be called once before any parsing is done.
-- Function init must be called before this function is called.
local function advance()
    -- Advance the iterator
    lexer_out_s, lexer_out_c = iter(state, lexer_out_s)

    -- If we're not past the end, copy current lexeme into vars
    if lexer_out_s ~= nil then
        lexstr, lexcat = lexer_out_s, lexer_out_c
    else
        lexstr, lexcat = "", 0
    end
end


-- init
-- Initial call. Sets input for parsing functions.
local function init(prog)
    iter, state, lexer_out_s = lexit.lex(prog)
    advance()
end


-- atEnd
-- Return true if pos has reached end of input.
-- Function init must be called before this function is called.
local function atEnd()
    return lexcat == 0
end


-- matchString
-- Given string, see if current lexeme string form is equal to it. If
--    so, then advance to next lexeme & return true. If not, then do not
--    advance, return false.
-- Function init must be called before this function is called.
local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end


-- matchCat
-- Given lexeme category (integer), see if current lexeme category is
--    equal to it. If so, then advance to next lexeme & return true. If
--    not, then do not advance, return false.
-- Function init must be called before this function is called.
local function matchCat(c)
    if lexcat == c then
        advance()
        return true
    else
        return false
    end
end

--[[****************************************************************]]--
--[[***         "local" statements for Parsing Functions         ***]]--
--[[****************************************************************]]--

local parse_program
local parse_stmt_list
local parse_statement
local parse_write_arg
local parse_expr
local parse_compare_expr
local parse_arith_expr
local parse_term
local parse_factor

--[[****************************************************************]]--
--[[***         The Parser: Function "parse" - EXPORTED          ***]]--
--[[****************************************************************]]--

-- parse
-- Given program, initialize parser and call parsing function for start
--   symbol. Returns pair of booleans & AST. First boolean indicates
--   successful parse or not. Second boolean indicates whether the parser
--   reached the end of the input or not. AST is only valid if first
--   boolean is true.
function parseit.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local good, ast = parse_program()  -- Parse start symbol
    local done = atEnd()

    -- And return them
    return good, done, ast
end

--[[*********************************************]]--
--[[***           Parsing Functions           ***]]--
--[[*********************************************]]--

-- Each of the following is a parsing function for a nonterminal in the
--    grammar. Each function parses the nonterminal in its name and returns
--    a pair: boolean, AST. On a successul parse, the boolean is true, the
--    AST is valid, and the current lexeme is just past the end of the
--    string the nonterminal expanded into. Otherwise, the boolean is
--    false, the AST is not valid, and no guarantees are made about the
--    current lexeme. See the AST Specification in the Assignment 4
--    description for the format of the returned AST.

-- NOTE. Declare parsing functions "local" above, but not below. This
--    allows them to be called before their definitions.


-- parse_program
-- Parsing function for nonterminal "program".
-- Function init must be called before this function is called.
function parse_program()
    local good, ast

    good, ast = parse_stmt_list()
    if not good then
        return false, nil
    end
    return true, ast
end


-- parse_stmt_list
-- Parsing function for nonterminal "stmt_list".
-- Function init must be called before this function is called.
function parse_stmt_list()
    local good, ast1, ast2

    ast1 = { STMT_LIST }
    while true do
        if lexstr == "write"
          or lexstr == "function"
          or lexstr == "if"
          or lexstr == "while"
          or lexstr == "return"
          or lexcat == lexit.ID then
            good, ast2 = parse_statement()
            if not good then
                return false, nil
            end
        else
            break
        end

        table.insert(ast1, ast2)
    end

    return true, ast1
end


-- parse_statement
-- Parsing function for nonterminal "statement".
-- Function init must be called before this function is called.
function parse_statement()
    local good, ast1, ast2, savelex

    if matchString("write") then
        if not matchString("(") then
            return false, nil
        end

        if matchString(")") then
            return true, { WRITE_STMT }
        end

        good, ast1 = parse_write_arg()
        if not good then
            return false, nil
        end

        ast2 = { WRITE_STMT, ast1 }

        while matchString(",") do
            good, ast1 = parse_write_arg()
            if not good then
                return false, nil
            end

            table.insert(ast2, ast1)
        end

        if not matchString(")") then
            return false, nil
        end

        return true, ast2

    elseif matchString("function") then
        savelex = lexstr
        if not matchCat(lexit.ID) then
            return false, nil
        end

        if not matchString("(") then
            return false, nil
        end
        if not matchString(")") then
            return false, nil
        end

        good, ast1 = parse_stmt_list()
        if not good then
            return false, nil
        end

        if not matchString("end") then
            return false, nil
        end

        return true, { FUNC_DEF, savelex, ast1 }
        
    elseif matchString("return") then
    
        good, ast1 = parse_expr()
        
        if good then
            return true, { RETURN_STMT, ast1 }
        else
            return false, nil

    elseif matchString("while") then

        good, ast1 = parse_expr()
        
        if not good then
            return false, nil        
        end

        if not matchString("do") then
            return false, nil
        end
        
        good, ast2 = parse_stmt_list()

        if not good then
            return false, nil
        end

        if not matchString("end") then
            return false, nil
        end
        
        return true, { WHILE_LOOP, ast1, ast2 }

    elseif matchString("if") or matchString("elseif") then
        
        good, ast1 = parse_expr()

        if not good then
            return false, nil
        end

        if not matchString("then") then
            return false, nil
        end

        ast2 = {IF_STMT , ast1}

        good, ast1 = parse_stmt_list()
        if not good then
            return false, nil
        end

        table.insert(ast2, ast1)

    elseif matchString("else") then

        good, ast1 = parse_stmt_list()
        if not good then
            return false, nil
        end

        table.insert(ast2, ast1)
        
        if not matchString("end") then
            return false,  nil
        end

        return true, ast2
        
    else

        savelex = lexstr

        if not matchCat(lexit.ID) then
            return false, nil
        end

        if matchString("(") then
            if not matchString(")") then
                return false, nil
            end

            return true, {FUNC_CALL, savelex}
        end

        if matchString("=") or matchString("[") then
            good, ast1 = parse_factor()
            if not good then
                return false, nil
            end

            good, ast2 = parse_expr()
            if not good then
                return false, nil
            end

            return true, {ASSN_STMT, ast1, ast2}
        end
        
        return false, nil  -- DUMMY
    end
end


-- parse_write_arg
-- Parsing function for nonterminal "write_arg".
-- Function init must be called before this function is called.
function parse_write_arg()
    local savelex, good, ast1

    savelex = lexstr
    if matchCat(lexit.STRLIT) then
        return true, { STRLIT_OUT, savelex }

    elseif matchString("cr") then
        return true, { CR_OUT }
    elseif matchString("char") then

        if not matchString("(") then
            return false, nil
        end

        good, ast1 = parse_expr()

        if not good then
            return false, nil
        end

        if not matchString(")") then
            return false, nil
        end

        return true, { CHAR_CALL, ast1 }
        
    else

        good, ast1 = parse_expr()

        if good then
            return good, ast1
        end
        
        return false, nil 
    end
end


-- parse_expr
-- Parsing function for nonterminal "expr".
-- Function init must be called before this function is called.
function parse_expr()
    -- TODO: WRITE THIS!!!
    return false, nil  -- DUMMY
end


-- parse_compare_expr
-- Parsing function for nonterminal "compare_expr".
-- Function init must be called before this function is called.
function parse_compare_expr()
    -- TODO: WRITE THIS!!!
    return false, nil  -- DUMMY
end


-- parse_arith_expr
-- Parsing function for nonterminal "arith_expr".
-- Function init must be called before this function is called.
function parse_arith_expr()
    -- TODO: WRITE THIS!!!
    return false, nil  -- DUMMY
end


-- parse_term
-- Parsing function for nonterminal "term".
-- Function init must be called before this function is called.
function parse_term()
    -- TODO: WRITE THIS!!!
    return false, nil  -- DUMMY
end


-- parse_factor
-- Parsing function for nonterminal "factor".
-- Function init must be called before this function is called.
function parse_factor()
    local good, ast1, ast2, savelex

    savelex = lexstr
    if matchCat(lexit.NUMLIT) then
        return true, {NUMLIT_VAL, savelex}
        
    elseif matchString("+") or matchString("-") or matchString("not") then
        good, ast1 = parse_factor()
        if not good then
            return false, nil
        end

        ast2 = {UN_OP, lexstr}
        return true, {ast2, ast1}
        
    elseif matchString("(") then
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
            
        if not matchString(")") then
            return false, nil
        end

        return true, {ast1}
        
    elseif matchString("read") then
        if not matchString("(") then
            return false, nil
        end

        if not matchString(")") then
            return false, nil
        end

        return true, {READ_CALL}
        
    elseif matchString("rand") then
        if not matchString("(") then
            return false, nil
        end

        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
            
        if not matchString(")") then
            return false, nil
        end

        return true, {RAND_CALL, ast1}
        
    elseif matchString("true") or matchString("false") then
        return true, {BOOLLIT_VAL, savelex}
    
    else
    
        return false, nil  -- DUMMY
    end
    -- TODO: WRITE THIS!!!
end

-- Module Table Return
return parseit
