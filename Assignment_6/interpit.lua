-- interpit.lua  SKELETON
-- Glenn G. Chappell
-- 2023-04-05
--
-- For CS 331 Spring 2023
-- Interpret AST from parseit.parse
-- Solution to Assignment 6, Exercise B


-- *** To run a Maleo program, use maleo.lua, which uses this file.


-- *********************************************************************
-- Module Table Initialization
-- *********************************************************************


local interpit = {}  -- Our module


-- *********************************************************************
-- Symbolic Constants for AST
-- *********************************************************************


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


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- numToInt
-- Given a number, return the number rounded toward zero.
local function numToInt(n)
    assert(type(n) == "number")

    if n >= 0 then
        return math.floor(n)
    else
        return math.ceil(n)
    end
end


-- strToNum
-- Given a string, attempt to interpret it as an integer. If this
-- succeeds, return the integer. Otherwise, return 0.
local function strToNum(s)
    assert(type(s) == "string")

    -- Try to do string -> number conversion; make protected call
    -- (pcall), so we can handle errors.
    local success, value = pcall(function() return tonumber(s) end)

    -- Return integer value, or 0 on error.
    if success and value ~= nil then
        return numToInt(value)
    else
        return 0
    end
end


-- numToStr
-- Given a number, return its string form.
local function numToStr(n)
    assert(type(n) == "number")

    return tostring(n)
end


-- boolToInt
-- Given a boolean, return 1 if it is true, 0 if it is false.
local function boolToInt(b)
    assert(type(b) == "boolean")

    if b then
        return 1
    else
        return 0
    end
end


-- astToStr
-- Given an AST, produce a string holding the AST in (roughly) Lua form,
-- with numbers replaced by names of symbolic constants used in parseit.
-- A table is assumed to represent an array.
-- See the Assignment 4 description for the AST Specification.
--
-- THIS FUNCTION IS INTENDED FOR USE IN DEBUGGING ONLY!
-- IT SHOULD NOT BE CALLED IN THE FINAL VERSION OF THE CODE.
function astToStr(x)
    local symbolNames = {
        "STMT_LIST", "WRITE_STMT", "FUNC_DEF", "IF_STMT", "WHILE_LOOP",
        "RETURN_STMT", "FUNC_CALL", "SIMPLE_VAR", "ARRAY_VAR",
        "ASSN_STMT", "STRLIT_OUT", "CR_OUT", "CHAR_CALL", "BIN_OP",
        "UN_OP", "NUMLIT_VAL", "BOOLLIT_VAL", "RAND_CALL", "READ_CALL",
    }
    if type(x) == "number" then
        local name = symbolNames[x]
        if name == nil then
            return "<Unknown numerical constant: "..x..">"
        else
            return name
        end
    elseif type(x) == "string" then
        return '"'..x..'"'
    elseif type(x) == "boolean" then
        if x then
            return "true"
        else
            return "false"
        end
    elseif type(x) == "table" then
        local first = true
        local result = "{"
        for k = 1, #x do
            if not first then
                result = result .. ","
            end
            result = result .. astToStr(x[k])
            first = false
        end
        result = result .. "}"
        return result
    elseif type(x) == "nil" then
        return "nil"
    else
        return "<"..type(x)..">"
    end
end


-- *********************************************************************
-- Primary Function for Client Code
-- *********************************************************************


-- interp
-- Interpreter, given AST returned by parseit.parse.
-- Parameters:
--   ast    - AST constructed by parseit.parse
--   state  - Table holding Maleo variables & functions
--            - AST for function xyz is in state.f["xyz"]
--            - Value of simple variable xyz is in state.v["xyz"]
--            - Value of array item xyz[42] is in state.a["xyz"][42]
--   util   - Table with 3 members, all functions:
--            - incall() inputs line, returns string with no newline
--            - outcall(str) outputs str with no added newline
--              To print a newline, do outcall("\n")
--            - random(n), for an integer n, returns a pseudorandom
--              integer from 0 to n-1, or 0 if n < 2.
-- Return Value:
--   state, updated with changed variable values
function interpit.interp(ast, state, util)
    -- Each local interpretation function is given the AST for the
    -- portion of the code it is interpreting. The function-wide
    -- versions of state and until may be used. The function-wide
    -- version of state may be modified as appropriate.


    -- Forward declare local functions
    local interp_stmt_list
    local interp_stmt
    local eval_expr


    -- interp_stmt_list
    -- Given the ast for a statement list, execute it.
    function interp_stmt_list(ast)
        for i = 2, #ast do
            interp_stmt(ast[i])
        end
    end


    -- interp_stmt
    -- Given the ast for a statement, execute it.
    function interp_stmt(ast)
        if ast[1] == WRITE_STMT then
            for i = 2, #ast do
                if ast[i][1] == STRLIT_OUT then
                    local str = ast[i][2]
                    util.output(str:sub(2, str:len()-1))
                elseif ast[i][1] == CR_OUT then
                    util.output("\n")
                elseif ast[i][1] == CHAR_CALL then
                    print("*** UNIMPLEMENTED WRITE ARG")
                else  -- Expression
                    local val = eval_expr(ast[i])
                    util.output(numToStr(val))
                end
            end
        elseif ast[1] == FUNC_DEF then
            local funcname = ast[2]
            local funcbody = ast[3]
            state.f[funcname] = funcbody
        elseif ast[1] == FUNC_CALL then
            local funcname = ast[2]
            local funcbody = state.f[funcname]
            if funcbody == nil then
                funcbody = { STMT_LIST }
            end
            interp_stmt_list(funcbody)
        else
            print("*** UNIMPLEMENTED STATEMENT")
        end
    end


    -- eval_expr
    -- Given the AST for an expression, evaluate it and return the
    -- value.
    function eval_expr(ast)
        local result

        if ast[1] == NUMLIT_VAL then
            result = strToNum(ast[2])
        else
            print("*** UNIMPLEMENTED EXPRESSION")
            result = 42  -- DUMMY VALUE
        end

        return result
    end


    -- Body of function interp
    interp_stmt_list(ast)
    return state
end


-- *********************************************************************
-- Module Table Return
-- *********************************************************************


return interpit

