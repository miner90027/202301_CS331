#!/usr/bin/env lua
-- parseit_test.lua
-- Glenn G. Chappell
-- 2023-02-24
--
-- For CS 331 Spring 2023
-- Test Program for Module parseit
-- Used in Assignment 4, Exercise A

parseit = require "parseit"  -- Import parseit module


-- *********************************************
-- * YOU MAY WISH TO CHANGE THE FOLLOWING LINE *
-- *********************************************

EXIT_ON_FIRST_FAILURE = true
-- If EXIT_ON_FIRST_FAILURE is true, then this program exits after the
-- first failing test. If it is false, then this program executes all
-- tests, reporting success/failure for each.


-- *********************************************************************
-- Testing Package
-- *********************************************************************


tester = {}
tester.countTests = 0
tester.countPasses = 0

function tester.test(self, success, testName)
    self.countTests = self.countTests+1
    io.write("    Test: " .. testName .. " - ")
    if success then
        self.countPasses = self.countPasses+1
        io.write("passed")
    else
        io.write("********** FAILED **********")
    end
    io.write("\n")
end

function tester.allPassed(self)
    return self.countPasses == self.countTests
end


-- *********************************************************************
-- Utility Functions
-- *********************************************************************


-- terminate
-- Called to end the program. Currently simply ends. To make the program
-- prompt the user and wait for the user to press ENTER, uncomment the
-- commented-out lines in the function body. The parameter is the
-- program's return value.
function terminate(status)
    -- Uncomment to following to wait for the user before terminating.
    --io.write("\nPress ENTER to quit ")
    --io.read("*l")

    os.exit(status)
end


function failExit()
    if EXIT_ON_FIRST_FAILURE then
        io.write("**************************************************\n")
        io.write("* This test program is configured to exit after  *\n")
        io.write("* the first failing test. To make it execute all *\n")
        io.write("* tests, reporting success/failure for each, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to false, near the start of the test program.  *\n")
        io.write("**************************************************\n")

        -- Terminate program, signaling error
        terminate(1)
    end
end


function endMessage(passed)
    if passed then
        io.write("All tests successful\n")
    else
        io.write("Tests ********** UNSUCCESSFUL **********\n")
        io.write("\n")
        io.write("**************************************************\n")
        io.write("* This test program is configured to execute all *\n")
        io.write("* tests, reporting success/failure for each. To  *\n")
        io.write("* make it exit after the first failing test, set *\n")
        io.write("* variable                                       *\n")
        io.write("*                                                *\n")
        io.write("*   EXIT_ON_FIRST_FAILURE                        *\n")
        io.write("*                                                *\n")
        io.write("* to true, near the start of the test program.   *\n")
        io.write("**************************************************\n")
    end
end


-- printValue
-- Given a value, print it in (roughly) Lua literal notation if it is
-- nil, number, string, boolean, or table -- calling this function
-- recursively for table keys and values. For other types, print an
-- indication of the type. The second argument, if passed, is max_items:
-- the maximum number of items in a table to print.
function printValue(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printValue: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printValue: max_items must be a number")
    end

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        io.write(x)
    elseif type(x) == "string" then
        io.write('"'..x..'"')
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) ~= "table" then
        io.write('<'..type(x)..'>')
    else  -- type is "table"
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in pairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" [")
                printValue(k, max_items)
                io.write("]=")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- printArray
-- Like printValue, but prints top-level tables as arrays.
-- Uses printValue.
-- The second argument, if passed, is max_items: the maximum number of
-- items in a table to print.
function printArray(...)
    assert(select("#", ...) == 1 or select("#", ...) == 2,
           "printArray: must pass 1 or 2 arguments")
    local x, max_items = select(1, ...)  -- Get args (may be nil)
    if type(max_items) ~= "nil" and type(max_items) ~= "number" then
        error("printArray: max_items must be a number")
    end

    if type(x) ~= "table" then
        printValue(x, max_items)
    else
        io.write("{")
        local first = true  -- First iteration of loop?
        local key_count, unprinted_count = 0, 0
        for k, v in ipairs(x) do
            key_count = key_count + 1
            if max_items ~= nil and key_count > max_items then
                unprinted_count = unprinted_count + 1
            else
                if first then
                    first = false
                else
                    io.write(",")
                end
                io.write(" ")
                printValue(v, max_items)
            end
        end
        if unprinted_count > 0 then
            if first then
                first = false
            else
                io.write(",")
            end
            io.write(" <<"..unprinted_count)
            if key_count - unprinted_count > 0 then
                io.write(" more")
            end
            if unprinted_count == 1 then
                io.write(" item>>")
            else
                io.write(" items>>")
            end
        end
        io.write(" }")
    end
end


-- equal
-- Compare equality of two values. Returns false if types are different.
-- Uses "==" on non-table values. For tables, recurses for the value
-- associated with each key.
function equal(...)
    assert(select("#", ...) == 2,
           "equal: must pass exactly 2 arguments")
    local x1, x2 = select(1, ...)  -- Get args (may be nil)

    local type1 = type(x1)
    if type1 ~= type(x2) then
        return false
    end

    if type1 ~= "table" then
       return x1 == x2
    end

    -- Get number of keys in x1 & check values in x1, x2 are equal
    local x1numkeys = 0
    for k, v in pairs(x1) do
        x1numkeys = x1numkeys + 1
        if not equal(v, x2[k]) then
            return false
        end
    end

    -- Check number of keys in x1, x2 same
    local x2numkeys = 0
    for k, v in pairs(x2) do
        x2numkeys = x2numkeys + 1
    end
    return x1numkeys == x2numkeys
end


-- getCoroutineValues
-- Given coroutine f, returns array of all values yielded by f when
-- passed param as its parameter, in the order the values are yielded.
function getCoroutineValues(f, param)
    assert(type(f)=="function",
           "getCoroutineValues: f is not a function")

    local covals = {}  -- Array of values yielded by coroutine f
    local co = coroutine.create(f)
    local ok, value = coroutine.resume(co, param)

    while (coroutine.status(co) ~= "dead") do
        table.insert(covals, value)
        ok, value = coroutine.resume(co)
    end

    -- Error in coroutine?
    if not ok then
        io.write("*** getCoroutineValues: error in coroutine:\n")
        io.write(value.."\n")  -- Print error trace
        terminate(1)
    end

    -- Return array of values
    return covals
end


-- *********************************************************************
-- Definitions for This Test Program
-- *********************************************************************


-- Symbolic Constants for AST
-- Names differ from those in assignment, to avoid interference.
local STMTxLIST    = 1
local WRITExSTMT   = 2
local FUNCxDEF     = 3
local IFxSTMT      = 4
local WHILExLOOP   = 5
local RETURNxSTMT  = 6
local FUNCxCALL    = 7
local SIMPLExVAR   = 8
local ARRAYxVAR    = 9
local ASSNxSTMT    = 10
local STRLITxOUT   = 11
local CRxOUT       = 12
local CHARxCALL    = 13
local BINxOP       = 14
local UNxOP        = 15
local NUMLITxVAL   = 16
local BOOLLITxVAL  = 17
local RANDxCALL    = 18
local READxCALL    = 19


-- String forms of symbolic constants
-- Used by printAST_parseit
symbolNames = {
  [1]="STMT_LIST",
  [2]="WRITE_STMT",
  [3]="FUNC_DEF",
  [4]="IF_STMT",
  [5]="WHILE_LOOP",
  [6]="RETURN_STMT",
  [7]="FUNC_CALL",
  [8]="SIMPLE_VAR",
  [9]="ARRAY_VAR",
  [10]="ASSN_STMT",
  [11]="STRLIT_OUT",
  [12]="CR_OUT",
  [13]="CHAR_CALL",
  [14]="BIN_OP",
  [15]="UN_OP",
  [16]="NUMLIT_VAL",
  [17]="BOOLLIT_VAL",
  [18]="RAND_CALL",
  [19]="READ_CALL",
}


-- printAST_parseit
-- Write an AST, in (roughly) Lua form, with numbers replaced by the
-- symbolic constants used in parseit, where possible.
-- See the Assignment description for the AST Specification.
function printAST_parseit(...)
    if select("#", ...) ~= 1 then
        error("printAST_parseit: must pass exactly 1 argument")
    end
    local x = select(1, ...)  -- Get argument (which may be nil)

    if type(x) == "nil" then
        io.write("nil")
    elseif type(x) == "number" then
        if symbolNames[x] then
            io.write(symbolNames[x])
        else
            io.write("<ERROR: Unknown constant: "..x..">")
        end
    elseif type(x) == "string" then
        io.write('"'..x..'"')
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) ~= "table" then
        io.write('<'..type(x)..'>')
    else  -- type is "table"
        io.write("{ ")
        local first = true  -- First iteration of loop?
        local maxk = 0
        for k, v in ipairs(x) do
            if first then
                first = false
            else
                io.write(", ")
            end
            maxk = k
            printAST_parseit(v)
        end
        for k, v in pairs(x) do
            if type(k) ~= "number"
              or k ~= math.floor(k)
              or (k < 1 and k > maxk) then
                if first then
                    first = false
                else
                    io.write(", ")
                end
                io.write("[")
                printAST_parseit(k)
                io.write("]=")
                printAST_parseit(v)
            end
        end
        io.write(" }")
    end
end


-- bool2Str
-- Given boolean, return string representing it: "true" or "false".
function bool2Str(b)
    if b then
        return "true"
    else
        return "false"
    end
end


-- checkParse
-- Given tester object, input string ("program"), expected output values
-- from parser (good, AST), and string giving the name of the test. Do
-- test & print result. If test fails and EXIT_ON_FIRST_FAILURE is true,
-- then print detailed results and exit program.
function checkParse(t, prog,
                    expectedGood, expectedDone, expectedAST,
                    testName)
    local actualGood, actualDone, actualAST = parseit.parse(prog)
    local sameGood = (expectedGood == actualGood)
    local sameDone = (expectedDone == actualDone)
    local sameAST = true
    if sameGood and expectedGood and sameDone and expectedDone then
        sameAST = equal(expectedAST, actualAST)
    end
    local success = sameGood and sameDone and sameAST
    t:test(success, testName)

    if success or not EXIT_ON_FIRST_FAILURE then
        return
    end

    io.write("\n")
    io.write("Input for the last test above:\n")
    io.write('"'..prog..'"\n')
    io.write("\n")
    io.write("Expected parser 'good' return value: ")
    io.write(bool2Str(expectedGood).."\n")
    io.write("Actual parser 'good' return value: ")
    io.write(bool2Str(actualGood).."\n")
    io.write("Expected parser 'done' return value: ")
    io.write(bool2Str(expectedDone).."\n")
    io.write("Actual parser 'done' return value: ")
    io.write(bool2Str(actualDone).."\n")
    if not sameAST then
        io.write("\n")
        io.write("Expected AST:\n")
        printAST_parseit(expectedAST)
        io.write("\n")
        io.write("\n")
        io.write("Returned AST:\n")
        printAST_parseit(actualAST)
        io.write("\n")
    end
    io.write("\n")
    failExit()
end


-- *********************************************************************
-- Test Suite Functions
-- *********************************************************************


function test_simple(t)
    io.write("Test Suite: simple cases\n")

    checkParse(t, "", true, true, {STMTxLIST},
      "Empty program")
    checkParse(t, "write", false, true, nil,
      "Bad program: Keyword only #1")
    checkParse(t, "elseif", true, false, nil,
      "Bad program: Keyword only #2")
    checkParse(t, "else", true, false, nil,
      "Bad program: Keyword only #3")
    checkParse(t, "ab", false, true, nil,
      "Bad program: Identifier only")
    checkParse(t, "123", true, false, nil,
      "Bad program: NumericLiteral only")
    checkParse(t, '"xyz"', true, false, nil,
      "Bad program: StringLiteral only")
    checkParse(t, "<=", true, false, nil,
      "Bad program: Operator only")
    checkParse(t, "{", true, false, nil,
      "Bad program: Punctuation only")
    checkParse(t, "\a", true, false, nil,
      "Bad program: Malformed only #1 (bad character)")
    checkParse(t, '"', true, false, nil,
      "bad program: malformed only #2 (bad string)")
end


function test_write_stmt_no_expr(t)
    io.write("Test Suite: write statements - no expressions\n")

    checkParse(t, "write()", true, true,
      {STMTxLIST,{WRITExSTMT}},
      "Write statement: no args")
    checkParse(t, "write()write()write()", true, true,
      {STMTxLIST,{WRITExSTMT},{WRITExSTMT},{WRITExSTMT}},
      "3 write statements")
    checkParse(t, "write(\"abc\")", true, true,
      {STMTxLIST,{WRITExSTMT,{STRLITxOUT,"\"abc\""}}},
      "Write statement: StringLiteral")
    checkParse(t, "write(\"a\",\"b\",\"c\",\"d\",\"e\")", true, true,
      {STMTxLIST,{WRITExSTMT,{STRLITxOUT,"\"a\""},{STRLITxOUT,"\"b\""},
        {STRLITxOUT,"\"c\""},{STRLITxOUT,"\"d\""},
        {STRLITxOUT,"\"e\""}}},
      "write statement: many StringLiterals")
    checkParse(t, "write();", true, false, nil,
      "Bad write statement: semicolon")
    checkParse(t, "write", false, true, nil,
      "Bad write statement: no parens, no arguments, no semicolon")
    checkParse(t, "write \"a\"", false, false, nil,
      "Bad write statement: no parens")
    checkParse(t, "write\"a\")", false, false, nil,
      "Bad write statement: no opening paren")
    checkParse(t, "write(\"a\"", false, true, nil,
      "Bad write statement: no closing paren")
    checkParse(t, "write(if)", false, false, nil,
      "Bad write statement: keyword #1")
    checkParse(t, "write(write)", false, false, nil,
      "Bad write statement: keyword #2")
    checkParse(t, "write(\"a\" \"b\")", false, false, nil,
      "Bad write statement: missing comma")
    checkParse(t, "write(,\"a\")", false, false, nil,
      "Bad write statement: comma without preceding argument")
    checkParse(t, "write(\"a\",)", false, false, nil,
      "Bad write statement: comma without following argument")
    checkParse(t, "write(,)", false, false, nil,
      "Bad write statement: comma alone")
    checkParse(t, "write(\"a\",,\"b\")", false, false, nil,
      "Bad write statement: extra comma")
    checkParse(t, "write(\"a\")else", true, false, nil,
      "Bad write statement: write followed by else")
    checkParse(t, "\"a\"", true, false, nil,
      "Bad program: (no write) string only")
end


function test_function_call_stmt(t)
    io.write("Test Suite: Function call statements\n")

    checkParse(t, "ff()", true, true,
      {STMTxLIST,{FUNCxCALL,"ff"}},
      "Function call statement #1")
    checkParse(t, "fffffffffffffffffffffffffffffffff()", true, true,
      {STMTxLIST,{FUNCxCALL,"fffffffffffffffffffffffffffffffff"}},
      "Function call statement #2")
    checkParse(t, "ff()gg()", true, true,
      {STMTxLIST,{FUNCxCALL,"ff"},{FUNCxCALL,"gg"}},
      "Two function call statements")
    checkParse(t, "ff();", true, false, nil,
      "Bad function call statement: semicolon")
    checkParse(t, "ff)", false, false, nil,
      "Bad function call statement: no left paren")
    checkParse(t, "ff(", false, true, nil,
      "Bad function call statement: no right paren")
    checkParse(t, "ff(()", false, false, nil,
      "Bad function call statement: extra left paren")
    checkParse(t, "ff())", true, false, nil,
      "Bad function call statement: extra right paren")
    checkParse(t, "ff()()", true, false, nil,
      "Bad function call statement: extra pair of parens")
    checkParse(t, "ff gg()", false, false, nil,
      "Bad function call statement: extra name")
    checkParse(t, "(ff)()", true, false, nil,
      "Bad function call statement: parentheses around name")
    checkParse(t, "ff(a)", false, false, nil,
      "Bad function call statement: argument - Idenitfier")
    checkParse(t, "ff(\"abc\")", false, false, nil,
      "Bad function call statement: argument - StringLiteral")
    checkParse(t, "ff(2)", false, false, nil,
      "Bad function call statement: argument - NumericLiteral")
end


function test_func_def_no_expr(t)
    io.write("Test Suite: function definitions - no expressions\n")

    checkParse(t, "function s()end", true, true,
      {STMTxLIST,{FUNCxDEF,"s",{STMTxLIST}}},
      "Function definition: empty body")
    checkParse(t, "function()end", false, false, nil,
      "Bad function definition: missing name")
    checkParse(t, "function end", false, false, nil,
      "Bad function definition: missing name & parens")
    checkParse(t, "function &s end", false, false, nil,
      "Bad function definition: ampersand before name")
    checkParse(t, "function s end", false, false, nil,
      "Bad function definition: no parens")
    checkParse(t, "function s()", false, true, nil,
      "Bad function definition: no end")
    checkParse(t, "function s(){}", false, false, nil,
      "Bad function definition: braces around body")
    checkParse(t, "function s())end", false, false, nil,
      "Bad function definition: extra right paren")
    checkParse(t, "function (s)()end", false, false, nil,
      "Bad function definition: name in parentheses")
    checkParse(t, "function s()write(\"abc\")end", true, true,
      {STMTxLIST,{FUNCxDEF,"s",{STMTxLIST,{WRITExSTMT,
        {STRLITxOUT,"\"abc\""}}}}},
      "Function definition: 1-statement body #1")
    checkParse(t, "function s()write(\"x\")end", true, true,
      {STMTxLIST,{FUNCxDEF,"s",{STMTxLIST,{WRITExSTMT,
        {STRLITxOUT,"\"x\""}}}}},
      "Function definition: 1-statment body #2")
    checkParse(t, "function s()write()write()end", true, true,
      {STMTxLIST,{FUNCxDEF,"s",{STMTxLIST,{WRITExSTMT},
        {WRITExSTMT}}}},
      "Function definition: 2-statment body")
    checkParse(t, "function sss()write()write()write()end",
      true, true,
      {STMTxLIST,{FUNCxDEF,"sss",{STMTxLIST,{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}}}},
      "Function definition: longer body")
    checkParse(t, "function s()function t()function u()write()end end"
     .." function v()write()end end", true, true,
      {STMTxLIST,{FUNCxDEF,"s",{STMTxLIST,{FUNCxDEF,"t",{STMTxLIST,
        {FUNCxDEF,"u",{STMTxLIST,{WRITExSTMT}}}}},{FUNCxDEF,
        "v",{STMTxLIST,{WRITExSTMT}}}}}},
      "Function definition: nested function definitions")
end


function test_while_loop_simple_expr(t)
    io.write("Test Suite: while loops - simple expressions only\n")

    checkParse(t, "while true do end", true, true,
      {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST}}},
      "While loop: true, empty")
    checkParse(t, "while true do write()end", true, true,
      {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST,
        {WRITExSTMT}}}},
      "While loop: true, 1 stmt in body")
    checkParse(t, "while true do write()write()write()write()"
     .."write()write()write()write()write()write()end", true,
     true,
      {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST,
        {WRITExSTMT},{WRITExSTMT},{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT},{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}}}},
      "While loop: true, longer statement list")
    checkParse(t, "while true do while true do while true do"
     .." while true do while true do while true do while true do"
     .." while true do while true do while true do while true do"
     .." while true do while true do while true do end end end end end"
     .." end end end end end end end end end", true, true,
      {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST}}}}}}}}}}}}}}}}}}}}}}}}}}}}},
      "While loop: true, nested")

    checkParse(t, "while do end", false, false, nil,
      "Bad while loop: no condition")
    checkParse(t, "while true end", false, false, nil,
      "Bad while loop: no do")
    checkParse(t, "while true", false, true, nil,
      "Bad while loop: no end")
    checkParse(t, "while while true do end", false, false, nil,
      "Bad while loop: extra while")
    checkParse(t, "while true true do end", false, false, nil,
      "Bad while loop: extra condition")
    checkParse(t, "while true do do end", false, false, nil,
      "Bad while loop: extra do")
    checkParse(t, "while true do end end", true, false, nil,
      "Bad while loop: extra end")
end


function test_if_stmt_simple_expr(t)
    io.write("Test Suite: if statements - simple expressions only\n")

    checkParse(t, "if true then end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST}}},
      "If statement: empty stmt list")
    checkParse(t, "if true then write()end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,
      {WRITExSTMT}}}},
      "If statement: one stmt in body")
    checkParse(t, "if true then else end", true,
      true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST},
      {STMTxLIST}}},
      "If statement: else")
    checkParse(t, "if true then elseif true then end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST},
        {BOOLLITxVAL,"true"},{STMTxLIST}}},
      "If statement: elseif, else")
    checkParse(t, "if true then write() elseif true then write()write()"
      .."elseif true then write()write()write()elseif true then write()"
      .."write()write()write()elseif true then write()write()write()"
      .."write()write()end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT},{WRITExSTMT}}}},
      "If statement: multiple elseif, no else")
    checkParse(t, "if true then write()elseif true then write()write()"
      .."elseif true then write()write()write()elseif true then write()"
      .."write()write()write()elseif true then write()write()write()"
      .."write()write()else write()write()write()write()write()"
      .."write()end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT}},
        {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT},{WRITExSTMT}},{STMTxLIST,{WRITExSTMT},
        {WRITExSTMT},{WRITExSTMT},{WRITExSTMT},{WRITExSTMT},
        {WRITExSTMT}}}},
      "If statement: multiple elseif, else")
    checkParse(t, "if true then if true then write()else write()end"
      .." elseif true then if true then write()else write()end else"
      .." if true then write()else write()end end", true, true,
        {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
          {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT}},{STMTxLIST,
          {WRITExSTMT}}}},{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
          {BOOLLITxVAL,"true"},{STMTxLIST,{WRITExSTMT}},{STMTxLIST,
          {WRITExSTMT}}}},{STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},
          {STMTxLIST,{WRITExSTMT}},{STMTxLIST,{WRITExSTMT}}}}}},
      "If statement: nested #1")
    checkParse(t, "if true then if true then if true then if true then"
      .." if true then if true then if true then write()end end end end"
      .." end end end", true, true,
      {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
        {BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},
        {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
        {BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},
        {STMTxLIST,{IFxSTMT,{BOOLLITxVAL,"true"},{STMTxLIST,
        {WRITExSTMT}}}}}}}}}}}}}}}},
      "If statement: nested #2")
    checkParse(t, "while true do if true then while true do end"
      .." elseif true then while true do if true then elseif true then"
      .." while true do end else while true do end end end end end",
      true, true,
      {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
        {BOOLLITxVAL,"true"},{STMTxLIST,{WHILExLOOP,
        {BOOLLITxVAL,"true"},{STMTxLIST}}},{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST,{IFxSTMT,
        {BOOLLITxVAL,"true"},{STMTxLIST},{BOOLLITxVAL,"true"},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},{STMTxLIST}}},
        {STMTxLIST,{WHILExLOOP,{BOOLLITxVAL,"true"},
        {STMTxLIST}}}}}}}}}}},
      "If statement: nested while & if")

    checkParse(t, "if then write()end", false, false, nil,
      "Bad if statement: no condition")
    checkParse(t, "if true write() end", false, false, nil,
      "Bad if statement: no then")
    checkParse(t, "if write() end", false, false, nil,
      "Bad if statement: no condition or then")
    checkParse(t, "if true then", false, true, nil,
      "Bad if statement: no end")
    checkParse(t, "if true true then end", false, false, nil,
      "Bad if statement: 2 expressions")
    checkParse(t, "if true then else elseif true then end",
      false, false, nil,
      "Bad if statement: else before elseif")
    checkParse(t, "if true then end end", true, false, nil,
      "Bad if statement: extra end")
end


function test_assn_stmt(t)
    io.write("Test Suite: assignment statements - simple expressions\n")

    checkParse(t, "abc=123", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"abc"},{NUMLITxVAL,"123"}}},
      "Assignment statement: NumericLiteral")
    checkParse(t, "abc=xyz", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR, "abc"},{SIMPLExVAR,"xyz"}}},
      "Assignment statement: identifier")
    checkParse(t, "abc[1]=xyz", true, true,
      {STMTxLIST,{ASSNxSTMT,{ARRAYxVAR,"abc",{NUMLITxVAL,"1"}},
        {SIMPLExVAR,"xyz"}}},
      "Assignment statement: array ref = ...")
    checkParse(t, "abc=true", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR, "abc"},{BOOLLITxVAL,"true"}}},
      "Assignment statement: boolean literal Keyword: true")
    checkParse(t, "abc=false", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR, "abc"},{BOOLLITxVAL,"false"}}},
      "Assignment statement: boolean literal Keyword: false")
    checkParse(t, "=123", true, false, nil,
      "Bad assignment statement: missing LHS")
    checkParse(t, "123=123", true, false, nil,
      "Bad assignment statement: LHS is NumericLiteral")
    checkParse(t, "else=123", true, false, nil,
      "Bad assignment statement: LHS is Keyword")
    checkParse(t, "abc 123", false, false, nil,
      "Bad assignment statement: missing assignment op")
    checkParse(t, "abc==123", false, false, nil,
      "Bad assignment statement: assignment op replaced by equality")
    checkParse(t, "abc=123;", true, false, nil,
      "Bad assignment statement: semicolon following")
    checkParse(t, "abc=", false, true, nil,
      "Bad assignment statement: RHS is empty")
    checkParse(t, "abc=else", false, false, nil,
      "Bad assignment statement: RHS is Keyword")
    checkParse(t, "abc=1 2", true, false, nil,
      "Bad assignment statement: RHS is two NumericLiterals")
    checkParse(t, "abc=1 else", true, false, nil,
      "Bad assignment statement: followed by else")

    checkParse(t, "x=foo()", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{FUNCxCALL,"foo"}}},
      "Simple expression: call")
    checkParse(t, "x=()", false, false, nil,
      "Bad expression: call without name")
    checkParse(t, "x=1and 2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: and")
    checkParse(t, "x=1 or 2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: or")
    checkParse(t, "x=1 + 2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (numbers with space)")
    checkParse(t, "x=1+2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (numbers without space)")
    checkParse(t, "x=a+2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary + (var+number)")
    checkParse(t, "x=1+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: binary + (number+var)")
    checkParse(t, "x=a+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: binary + (vars)")
    checkParse(t, "x=1+", false, true, nil,
      "Bad expression: end with +")
    checkParse(t, "x=1 - 2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary - (numbers with space)")
    checkParse(t, "x=1-2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: binary - (numbers without space)")
    checkParse(t, "x=1-", false, true, nil,
      "Bad expression: end with -")
    checkParse(t, "x=1*2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: * (numbers)")
    checkParse(t, "x=a*2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: * (var*number)")
    checkParse(t, "x=1*b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: * (number*var)")
    checkParse(t, "x=a*b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: * (vars)")
    checkParse(t, "x=1*", false, true, nil,
      "Bad expression: end with *")
    checkParse(t, "x=1/2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: /")
    checkParse(t, "x=1/", false, true, nil,
      "Bad expression: end with /")
    checkParse(t, "x=1%2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: % #1")
    checkParse(t, "x=1%true", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {NUMLITxVAL,"1"},{BOOLLITxVAL,"true"}}}},
      "Simple expression: % #2")
    checkParse(t, "x=1%false", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},
        {NUMLITxVAL,"1"},{BOOLLITxVAL,"false"}}}},
      "Simple expression: % #3")
    checkParse(t, "x=1%", false, true, nil,
      "Bad expression: end with %")
    checkParse(t, "x=1==2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: == (numbers)")
    checkParse(t, "x=a==2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"2"}}}},
      "Simple expression: == (var==number)")
    checkParse(t, "x=1==b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {NUMLITxVAL,"1"},{SIMPLExVAR,"b"}}}},
      "Simple expression: == (number==var)")
    checkParse(t, "x=a==b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}},
      "Simple expression: == (vars)")
    checkParse(t, "x=1==", false, true, nil,
      "Bad expression: end with ==")
    checkParse(t, "x=1!=2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: !=")
    checkParse(t, "x=1!=", false, true, nil,
      "Bad expression: end with !=")
    checkParse(t, "x=1<2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: <")
    checkParse(t, "x=1<", false, true, nil,
      "Bad expression: end with <")
    checkParse(t, "x=1<=2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: <=")
    checkParse(t, "x=1<=", false, true, nil,
      "Bad expression: end with <=")
    checkParse(t, "x=1>2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: >")
    checkParse(t, "x=1>", false, true, nil,
      "Bad expression: end with >")
    checkParse(t, "x=1>=2", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},
        {NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}}},
      "Simple expression: >=")
    checkParse(t, "x=+a", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{SIMPLExVAR,
        "a"}}}},
      "Simple expression: unary +")
    checkParse(t, "x=-a", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{SIMPLExVAR,
        "a"}}}},
      "Simple expression: unary -")
    checkParse(t, "x=1>=", false, true, nil,
      "Bad expression: end with >=")
    checkParse(t, "x=(1)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{NUMLITxVAL,"1"}}},
      "Simple expression: parens (number)")
    checkParse(t, "x=(a)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"a"}}},
      "Simple expression: parens (var)")
    checkParse(t, "x=a[1]", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{ARRAYxVAR,"a",
        {NUMLITxVAL,"1"}}}},
      "Simple expression: array ref")
    checkParse(t, "x=(1", false, true, nil,
      "Bad expression: no closing paren")
    checkParse(t, "x=()", false, false, nil,
      "Bad expression: empty parens")
    checkParse(t, "x=a[1", false, true, nil,
      "Bad expression: no closing bracket")
    checkParse(t, "x=a 1]", true, false, nil,
      "Bad expression: no opening bracket")
    checkParse(t, "x=a[]", false, false, nil,
      "Bad expression: empty brackets")
    checkParse(t, "x=(x)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"x"}}},
      "Simple expression: var in parens on RHS")
    checkParse(t, "(x)=x", true, false, nil,
      "Bad expression: var in parens on LHS")
    checkParse(t, "x[1]=(x[1])", true, true,
      {STMTxLIST,{ASSNxSTMT,{ARRAYxVAR,"x",{NUMLITxVAL,"1"}},
        {ARRAYxVAR,"x",{NUMLITxVAL,"1"}}}},
      "Simple expression: array ref in parens on RHS")
    checkParse(t, "(x[1])=x[1]", true, false, nil,
      "Bad expression: array ref in parens on LHS")

    checkParse(t, "x=f()()", true, false, nil,
      "Bad expression: call function call")
    checkParse(t, "x=3()", true, false, nil,
      "Bad expression: call number")
    checkParse(t, "x=true()", true, false, nil,
      "Bad expression: call boolean")
    checkParse(t, "x=(x)()", true, false, nil,
      "Bad expression: call with parentheses around ID")
end


function test_return_stmt(t)
    io.write("Test Suite: return statements\n")

    checkParse(t, "return x", true, true,
      {STMTxLIST,{RETURNxSTMT,{SIMPLExVAR,"x"}}},
      "return statement: variable")
    checkParse(t, "return x;", true, false, nil,
      "bad return statement: semicolon")
    checkParse(t, "return -34", true, true,
      {STMTxLIST,{RETURNxSTMT,{{UNxOP,"-"},{NUMLITxVAL,"34"}}}},
      "return statement: number")
    checkParse(t, "return", false, true, nil,
      "return statement: no argument")
    checkParse(t, "return(x)", true, true,
      {STMTxLIST,{RETURNxSTMT,{SIMPLExVAR,"x"}}},
      "return statement: variable in parentheses")
    checkParse(t, "return(3+true<=4*(x-y))", true, true,
      {STMTxLIST,{RETURNxSTMT,{{BINxOP,"<="},{{BINxOP,"+"},{NUMLITxVAL,
        "3"},{BOOLLITxVAL,"true"}},{{BINxOP,"*"},{NUMLITxVAL,"4"},
        {{BINxOP,"-"},{SIMPLExVAR,"x"},{SIMPLExVAR,"y"}}}}}},
      "return statement: fancier expression")
end


function test_write_stmt_with_expr(t)
    io.write("Test Suite: write statements - with expressions\n")

    checkParse(t, "write(x)", true, true,
      {STMTxLIST,{WRITExSTMT,{SIMPLExVAR,"x"}}},
      "write statement: variable")
    checkParse(t, "write(char(65))", true, true,
      {STMTxLIST,{WRITExSTMT,{CHARxCALL,{NUMLITxVAL,"65"}}}},
      "write statement: char call")
    checkParse(t, "write(char(1),char(2),char(3))", true, true,
      {STMTxLIST,{WRITExSTMT,{CHARxCALL,{NUMLITxVAL,"1"}},{CHARxCALL,
        {NUMLITxVAL,"2"}},{CHARxCALL,{NUMLITxVAL,"3"}}}},
      "write statement: multiple char calls")
    checkParse(t, "write(\"a b\", char(1+2), a*4)", true, true,
      {STMTxLIST,{WRITExSTMT,{STRLITxOUT,"\"a b\""},{CHARxCALL,
        {{BINxOP,"+"},{NUMLITxVAL,"1"},{NUMLITxVAL,"2"}}},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{NUMLITxVAL,"4"}}}},
      "write statement: string literal, char call, expression #1")
    checkParse(t, "write(char(1-2), \"a b\", 4/a)", true, true,
      {STMTxLIST,{WRITExSTMT,{CHARxCALL,{{BINxOP,"-"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}}},{STRLITxOUT,"\"a b\""},{{BINxOP,"/"},
        {NUMLITxVAL,"4"},{SIMPLExVAR,"a"}}}},
      "write statement: string literal, char call, expression #2")
    checkParse(t, "write(a+xyz_3[b*(c==d-f)]%g<=h)", true, true,
      {STMTxLIST,{WRITExSTMT,{{BINxOP,"<="},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{ARRAYxVAR,"xyz_3",{{BINxOP,"*"},{SIMPLExVAR,
        "b"},{{BINxOP,"=="},{SIMPLExVAR,"c"},{{BINxOP,"-"},{SIMPLExVAR,
        "d"},{SIMPLExVAR,"f"}}}}},{SIMPLExVAR,"g"}}},{SIMPLExVAR,
        "h"}}}},
      "write statement: complex expression")
    checkParse(t, "write(1);", true, false, nil,
      "bad write statement: emicolon")
end


function test_func_def_with_expr(t)
    io.write("Test Suite: function definitions - with expressions\n")

    checkParse(t, "function q()write(abc+3)end", true, true,
      {STMTxLIST,{FUNCxDEF,"q",{STMTxLIST,{WRITExSTMT,{{BINxOP,"+"},
        {SIMPLExVAR,"abc"},{NUMLITxVAL,"3"}}}}}},
      "function definition: with write expr")
    checkParse(t, "function qq()write(a+x[b*(c==d-f)]%g<=h)end",
      true, true,
      {STMTxLIST,{FUNCxDEF,"qq",{STMTxLIST,{WRITExSTMT,{{BINxOP,"<="},
        {{BINxOP,"+"},{SIMPLExVAR,"a"},{{BINxOP,"%"},{ARRAYxVAR,"x",
        {{BINxOP,"*"},{SIMPLExVAR,"b"},{{BINxOP,"=="},{SIMPLExVAR,"c"},
        {{BINxOP,"-"},{SIMPLExVAR,"d"},{SIMPLExVAR,"f"}}}}},{SIMPLExVAR,
        "g"}}},{SIMPLExVAR,"h"}}}}}},
      "function definition: complex expression")
end


function test_expr_prec_assoc(t)
    io.write("Test Suite: expressions - precedence & associativity\n")

    checkParse(t, "x=1and 2and 3and 4and 5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},{{BINxOP,
        "and"},{{BINxOP, "and"},{{BINxOP,"and"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator 'and' is left-associative")
    checkParse(t, "x=1 or 2 or 3 or 4 or 5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{{BINxOP,
        "or"},{{BINxOP, "or"},{{BINxOP,"or"},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator 'or' is left-associative")
    checkParse(t, "x=1+2+3+4+5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "+"},{{BINxOP, "+"},{{BINxOP,"+"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Binary operator + is left-associative")
    checkParse(t, "x=1-2-3-4-5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "-"},{{BINxOP, "-"},{{BINxOP,"-"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Binary operator - is left-associative")
    checkParse(t, "x=1*2*3*4*5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "*"},{{BINxOP, "*"},{{BINxOP,"*"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator * is left-associative")
    checkParse(t, "x=1/2/3/4/5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "/"},{{BINxOP, "/"},{{BINxOP,"/"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator / is left-associative")
    checkParse(t, "x=1%2%3%4%5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "%"},{{BINxOP, "%"},{{BINxOP,"%"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator % is left-associative")
    checkParse(t, "x=1==2==3==4==5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "=="},{{BINxOP, "=="},{{BINxOP,"=="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator == is left-associative")
    checkParse(t, "x=1!=2!=3!=4!=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{BINxOP,
        "!="},{{BINxOP, "!="},{{BINxOP,"!="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator != is left-associative")
    checkParse(t, "x=1<2<3<4<5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{BINxOP,
        "<"},{{BINxOP, "<"},{{BINxOP,"<"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator < is left-associative")
    checkParse(t, "x=1<=2<=3<=4<=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{BINxOP,
        "<="},{{BINxOP, "<="},{{BINxOP,"<="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator <= is left-associative")
    checkParse(t, "x=1>2>3>4>5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        ">"},{{BINxOP, ">"},{{BINxOP,">"},{NUMLITxVAL,"1"},{NUMLITxVAL,
        "2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}}}},
      "Operator > is left-associative")
    checkParse(t, "x=1>=2>=3>=4>=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">="},{{BINxOP, ">="},{{BINxOP,">="},{NUMLITxVAL,"1"},
        {NUMLITxVAL,"2"}},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}},
        {NUMLITxVAL,"5"}}}},
      "Operator >= is left-associative")

    checkParse(t, "x=not not not not a", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"not"},
        {{UNxOP,"not"},{{UNxOP,"not"},{{UNxOP,"not"},
        {SIMPLExVAR,"a"}}}}}}},
      "Operator 'not' is right-associative")
    checkParse(t, "x=++++a", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{UNxOP,"+"},
        {{UNxOP,"+"},{{UNxOP,"+"},{SIMPLExVAR,"a"}}}}}}},
      "Unary operator + is right-associative")
    checkParse(t, "x=- - - -a", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{UNxOP,"-"},
        {{UNxOP,"-"},{{UNxOP,"-"},{SIMPLExVAR,"a"}}}}}}},
      "Unary operator - is right-associative")

    checkParse(t, "x=a and b or c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{{BINxOP,
        "and"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: and, or")
    checkParse(t, "x=a and b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, ==")
    checkParse(t, "x=a and b!=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, !=")
    checkParse(t, "x=a and b<c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, <")
    checkParse(t, "x=a and b<=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"<="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, <=")
    checkParse(t, "x=a and b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
      {SIMPLExVAR,"a"},{{BINxOP,">"},{SIMPLExVAR,"b"},
      {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, >")
    checkParse(t, "x=a and b>=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,">="},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, >=")
    checkParse(t, "x=a and b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, binary +")
    checkParse(t, "x=a and b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, binary -")
    checkParse(t, "x=a and b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, *")
    checkParse(t, "x=a and b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, /")
    checkParse(t, "x=a and b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},
        {SIMPLExVAR,"a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},
        {SIMPLExVAR,"c"}}}}},
      "Precedence check: and, %")

    checkParse(t, "x=a or b and c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},{{BINxOP,
        "or"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: or, and")
    checkParse(t, "x=a or b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, ==")
    checkParse(t, "x=a or b!=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check:  or , !=")
    checkParse(t, "x=a or b<c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, <")
    checkParse(t, "x=a or b<=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"<="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, <=")
    checkParse(t, "x=a or b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,">"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, >")
    checkParse(t, "x=a or b>=c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,">="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, >=")
    checkParse(t, "x=a or b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, binary +")
    checkParse(t, "x=a or b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, binary -")
    checkParse(t, "x=a or b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, *")
    checkParse(t, "x=a or b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, /")
    checkParse(t, "x=a or b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: or, %")

    checkParse(t, "x=a==b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "=="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: ==, >")
    checkParse(t, "x=a==b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, binary +")
    checkParse(t, "x=a==b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, binary -")
    checkParse(t, "x=a==b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, *")
    checkParse(t, "x=a==b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, /")
    checkParse(t, "x=a==b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: ==, %")

    checkParse(t, "x=a>b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        ">"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: >, ==")
    checkParse(t, "x=a>b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, binary +")
    checkParse(t, "x=a>b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"-"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, binary -")
    checkParse(t, "x=a>b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, *")
    checkParse(t, "x=a>b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, /")
    checkParse(t, "x=a>b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: >, %")

    checkParse(t, "x=a+b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, ==")
    checkParse(t, "x=a+b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, >")
    checkParse(t, "x=a+b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary +, binary -")
    checkParse(t, "x=a+b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, *")
    checkParse(t, "x=a+b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, /")
    checkParse(t, "x=a+b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary +, %")

    checkParse(t, "x=a-b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, ==")
    checkParse(t, "x=a-b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, >")
    checkParse(t, "x=a-b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: binary -, binary +")
    checkParse(t, "x=a-b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, *")
    checkParse(t, "x=a-b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"/"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, /")
    checkParse(t, "x=a-b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{BINxOP,"%"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence check: binary -, %")

    checkParse(t, "x=a*b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, ==")
    checkParse(t, "x=a*b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, >")
    checkParse(t, "x=a*b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, binary +")
    checkParse(t, "x=a*b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, binary -")
    checkParse(t, "x=a*b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, /")
    checkParse(t, "x=a*b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "*"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: *, %")

    checkParse(t, "x=a/b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, ==")
    checkParse(t, "x=a/b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, >")
    checkParse(t, "x=a/b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, binary +")
    checkParse(t, "x=a/b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, binary -")
    checkParse(t, "x=a/b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, *")
    checkParse(t, "x=a/b%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "/"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: /, %")

    checkParse(t, "x=a%b==c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, ==")
    checkParse(t, "x=a%b>c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, >")
    checkParse(t, "x=a%b+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, binary +")
    checkParse(t, "x=a%b-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, binary -")
    checkParse(t, "x=a%b*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, *")
    checkParse(t, "x=a%b/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "%"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: %, /")

    checkParse(t, "x=not a and b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, and")
    checkParse(t, "x=not a or b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, or")
    checkParse(t, "x=not a==b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, ==")
    checkParse(t, "x=not a!=b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, !=")
    checkParse(t, "x=not a<b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, <")
    checkParse(t, "x=not a<=b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, <=")
    checkParse(t, "x=not a>b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, >")
    checkParse(t, "x=not a>=b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, >=")
    checkParse(t, "x=not a+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, binary +")
    checkParse(t, "x=not a-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, binary -")
    checkParse(t, "x=not a*b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, *")
    checkParse(t, "x=not a/b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, /")
    checkParse(t, "x=not a%b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{UNxOP,
        "not"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: not, %")
    checkParse(t, "x=a!=+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: !=, unary +")
    checkParse(t, "x=-a<c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{UNxOP,
        "-"},{SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary -, <")
    checkParse(t, "x=a++b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary +, unary +")
    checkParse(t, "x=a+-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary +, unary -")
    checkParse(t, "x=+a+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary +, binary +, *")
    checkParse(t, "x=-a+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary -, binary +")
    checkParse(t, "x=a-+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary -, unary +")
    checkParse(t, "x=a- -b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: binary -, unary -")
    checkParse(t, "x=+a-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary +, binary -, *")
    checkParse(t, "x=-a-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"b"}}}},
      "Precedence check: unary -, binary -")
    checkParse(t, "x=a*-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: *, unary -")
    checkParse(t, "x=+a*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary +, *")
    checkParse(t, "x=a/+b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{SIMPLExVAR,
        "a"},{{UNxOP,"+"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: /, unary +")
    checkParse(t, "x=-a/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{UNxOP,"-"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary -, /")
    checkParse(t, "x=a%-b", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{SIMPLExVAR,
        "a"},{{UNxOP,"-"},{SIMPLExVAR,"b"}}}}},
      "Precedence check: %, unary -")
    checkParse(t, "x=+a%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{UNxOP,"+"},
        {SIMPLExVAR,"a"}},{SIMPLExVAR,"c"}}}},
      "Precedence check: unary +, %")

    checkParse(t, "x=1 and (2 and 3 and 4) and 5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"and"},{{BINxOP,
        "and"},{NUMLITxVAL,"1"},{{BINxOP,"and"},{{BINxOP,"and"},
          {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
          {NUMLITxVAL,"5"}}}},
      "Associativity override: and")
    checkParse(t, "x=1 or (2 or 3 or 4) or 5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"or"},{{BINxOP,
        "or"},{NUMLITxVAL,"1"},{{BINxOP,"or"},{{BINxOP,"or"},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: or")
    checkParse(t, "x=1==(2==3==4)==5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{{BINxOP,
        "=="},{NUMLITxVAL,"1"},{{BINxOP,"=="},{{BINxOP,"=="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: ==")
    checkParse(t, "x=1!=(2!=3!=4)!=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"!="},{{BINxOP,
        "!="},{NUMLITxVAL,"1"},{{BINxOP,"!="},{{BINxOP,"!="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: !=")
    checkParse(t, "x=1<(2<3<4)<5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},{{BINxOP,
        "<"},{NUMLITxVAL,"1"},{{BINxOP,"<"},{{BINxOP,"<"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: <")
    checkParse(t, "x=1<=(2<=3<=4)<=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<="},{{BINxOP,
        "<="},{NUMLITxVAL,"1"},{{BINxOP,"<="},{{BINxOP,"<="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: <=")
    checkParse(t, "x=1>(2>3>4)>5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">"},{{BINxOP,
        ">"},{NUMLITxVAL,"1"},{{BINxOP,">"},{{BINxOP,">"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: >")
    checkParse(t, "x=1>=(2>=3>=4)>=5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">="},{NUMLITxVAL,"1"},{{BINxOP,">="},{{BINxOP,">="},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: >=")
    checkParse(t, "x=1+(2+3+4)+5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},
        {{BINxOP,"+"},{NUMLITxVAL,"1"},{{BINxOP,"+"},{{BINxOP,"+"},
        {NUMLITxVAL,"2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},
        {NUMLITxVAL,"5"}}}},
      "Associativity override: binary +")
    checkParse(t, "x=1-(2-3-4)-5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "-"},{NUMLITxVAL,"1"},{{BINxOP,"-"},{{BINxOP,"-"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: binary -")
    checkParse(t, "x=1*(2*3*4)*5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "*"},{NUMLITxVAL,"1"},{{BINxOP,"*"},{{BINxOP,"*"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: *")
    checkParse(t, "x=1/(2/3/4)/5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "/"},{NUMLITxVAL,"1"},{{BINxOP,"/"},{{BINxOP,"/"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: /")
    checkParse(t, "x=1%(2%3%4)%5", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "%"},{NUMLITxVAL,"1"},{{BINxOP,"%"},{{BINxOP,"%"},{NUMLITxVAL,
        "2"},{NUMLITxVAL,"3"}},{NUMLITxVAL,"4"}}},{NUMLITxVAL,"5"}}}},
      "Associativity override: %")

    checkParse(t, "x=(a==b)+c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{{BINxOP,
        "=="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: ==, binary +")
    checkParse(t, "x=(a!=b)-c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"-"},{{BINxOP,
        "!="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: !=, binary -")
    checkParse(t, "x=(a<b)*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "<"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: <, *")
    checkParse(t, "x=(a<=b)/c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{{BINxOP,
        "<="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: <=, /")
    checkParse(t, "x=(a>b)%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        ">"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: >, %")
    checkParse(t, "x=a+(b>=c)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"+"},{SIMPLExVAR,
       "a"},{{BINxOP,">="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: binary +, >=")
    checkParse(t, "x=(a-b)*c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{{BINxOP,
        "-"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: binary -, *")
    checkParse(t, "x=(a+b)%c", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{{BINxOP,
        "+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},{SIMPLExVAR,"c"}}}},
      "Precedence override: binary +, %")
    checkParse(t, "x=a*(b==c)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"*"},{SIMPLExVAR,
        "a"},{{BINxOP,"=="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: *, ==")
    checkParse(t, "x=a/(b!=c)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"/"},{SIMPLExVAR,
        "a"},{{BINxOP,"!="},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: /, !=")
    checkParse(t, "x=a%(b<c)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"%"},{SIMPLExVAR,
        "a"},{{BINxOP,"<"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}}}}},
      "Precedence override: %, <")

    checkParse(t, "x=+(a<=b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,
        "<="},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, <=")
    checkParse(t, "x=-(a>b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,">"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, >")
    checkParse(t, "x=+(a+b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"+"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, binary +")
    checkParse(t, "x=-(a-b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,"-"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, binary -")
    checkParse(t, "x=+(a*b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, *")
    checkParse(t, "x=-(a/b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"-"},{{BINxOP,"/"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary -, /")
    checkParse(t, "x=+(a%b)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{UNxOP,"+"},{{BINxOP,"%"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"b"}}}}},
      "Precedence override: unary +, %")
end


function test_read_rand(t)
    io.write("Test Suite: read & rand\n")

    checkParse(t, "x=read()", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{READxCALL}}},
      "Assignment with read")
    checkParse(t, "x=read(y)", false, false, nil,
      "Assignment with read - nonempty parens")
    checkParse(t, "x=read", false, true, nil,
      "Assignment with read - no parens")
    checkParse(t, "x=read)", false, false, nil,
      "Assignment with read - no left paren")
    checkParse(t, "x=read(", false, true, nil,
      "Assignment with read - no right paren")
    checkParse(t, "read()", true, false, nil,
      "read as statement")
    checkParse(t, "x=read()y=read()", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{READxCALL}},{ASSNxSTMT,
        {SIMPLExVAR,"y"},{READxCALL}}},
      "Multiple assignments with read")

    checkParse(t, "x=rand(1)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{RANDxCALL,
      {NUMLITxVAL,"1"}}}},
      "Assignment with rand")
    checkParse(t, "x=rand()", false, false, nil,
      "Assignment with rand - empty parens")
    checkParse(t, "x=rand", false, true, nil,
      "Assignment with rand - no parens")
    checkParse(t, "x=rand 1)", false, false, nil,
      "Assignment with rand - no left paren")
    checkParse(t, "x=rand(1", false, true, nil,
      "Assignment with rand - no right paren")
    checkParse(t, "rand(1)", true, false, nil,
      "read as statement")
    checkParse(t, "x=rand(a)y=rand(false)", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{RANDxCALL,
        {SIMPLExVAR,"a"}}},{ASSNxSTMT,{SIMPLExVAR,"y"},{RANDxCALL,
        {BOOLLITxVAL,"false"}}}},
      "Multiple assignments with rand")
end


function test_array_item(t)
    io.write("Test Suite: array items\n")

    checkParse(t, "a[1] = 2", true, true,
      {STMTxLIST,{ASSNxSTMT,{ARRAYxVAR,"a",{NUMLITxVAL,"1"}},
        {NUMLITxVAL,"2"}}},
      "Array item in LHS of assignment")
    checkParse(t, "a = b[2]", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"a"},{ARRAYxVAR,"b",{NUMLITxVAL,
        "2"}}}},
      "Array item in RHS of assignment")
    checkParse(t, "abc[5*2+a]=bcd[5<=true/4]/cde[not false>x]",
      true, true,
      {STMTxLIST,{ASSNxSTMT,{ARRAYxVAR,"abc",{{BINxOP,"+"},{{BINxOP,
        "*"},{NUMLITxVAL,"5"},{NUMLITxVAL,"2"}},{SIMPLExVAR,"a"}}},
        {{BINxOP,"/"},{ARRAYxVAR,"bcd",{{BINxOP,"<="},{NUMLITxVAL,"5"},
        {{BINxOP,"/"},{BOOLLITxVAL,"true"},{NUMLITxVAL,"4"}}}},
        {ARRAYxVAR,"cde",{{BINxOP,">"},{{UNxOP,"not"},{BOOLLITxVAL,
        "false"}},{SIMPLExVAR,"x"}}}}}},
      "Array items: fancier")
end


function test_expr_complex(t)
    io.write("Test Suite: complex expressions\n")

    checkParse(t, "x=((((((((((((((((((((((((((((((((((((((((a)))"
      ..")))))))))))))))))))))))))))))))))))))", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{SIMPLExVAR,"a"}}},
      "Complex expression: many parens")
    checkParse(t, "x=(((((((((((((((((((((((((((((((((((((((a))))"
      .."))))))))))))))))))))))))))))))))))))", true, false, nil,
      "Bad complex expression: many parens, mismatch #1")
    checkParse(t, "x=((((((((((((((((((((((((((((((((((((((((a)))"
      .."))))))))))))))))))))))))))))))))))))", false, true, nil,
      "Bad complex expression: many parens, mismatch #2")
    checkParse(t, "x=a==b+c[x-y[2]]*+d!=e-f/-g<h+i%+j", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"<"},
        {{BINxOP,"!="},{{BINxOP,"=="},{SIMPLExVAR,"a"},{{BINxOP,"+"},
        {SIMPLExVAR,"b"},{{BINxOP,"*"},{ARRAYxVAR,"c",{{BINxOP,"-"},
        {SIMPLExVAR,"x"},{ARRAYxVAR,"y",{NUMLITxVAL,"2"}}}},{{UNxOP,
        "+"},{SIMPLExVAR,"d"}}}}},{{BINxOP,"-"},{SIMPLExVAR,"e"},
        {{BINxOP,"/"},{SIMPLExVAR,"f"},{{UNxOP,"-"},{SIMPLExVAR,
        "g"}}}}},{{BINxOP,"+"},{SIMPLExVAR,"h"},{{BINxOP,"%"},
        {SIMPLExVAR,"i"},{{UNxOP,"+"},{SIMPLExVAR,"j"}}}}}}},
      "Complex expression: misc #1")
    checkParse(t, "x=a==b+(c*+(d!=e[2*z]-f/-g)<h+i)%+j", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,"=="},{SIMPLExVAR,
        "a"},{{BINxOP,"+"},{SIMPLExVAR,"b"},{{BINxOP,"%"},{{BINxOP,"<"},
        {{BINxOP,"*"},{SIMPLExVAR,"c"},{{UNxOP,"+"},{{BINxOP,"!="},
        {SIMPLExVAR,"d"},{{BINxOP,"-"},{ARRAYxVAR,"e",{{BINxOP,"*"},
        {NUMLITxVAL,"2"},{SIMPLExVAR,"z"}}},{{BINxOP,"/"},{SIMPLExVAR,
        "f"},{{UNxOP,"-"},{SIMPLExVAR,"g"}}}}}}},{{BINxOP,"+"},
        {SIMPLExVAR,"h"},{SIMPLExVAR,"i"}}},{{UNxOP,"+"},{SIMPLExVAR,
        "j"}}}}}}},
      "Complex expression: misc #2")
    checkParse(t, "x=a[x[y[z]]%4]++b*c<=d- -e/f>g+-h%i>=j", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},{{BINxOP,
        ">"},{{BINxOP,"<="},{{BINxOP,"+"},{ARRAYxVAR,"a",{{BINxOP,"%"},
        {ARRAYxVAR,"x",{ARRAYxVAR,"y",{SIMPLExVAR,"z"}}},{NUMLITxVAL,
        "4"}}},{{BINxOP,"*"},{{UNxOP,"+"},{SIMPLExVAR,"b"}},{SIMPLExVAR,
        "c"}}},{{BINxOP,"-"},{SIMPLExVAR,"d"},{{BINxOP,"/"},
        {{UNxOP,"-"},{SIMPLExVAR,"e"}},{SIMPLExVAR,"f"}}}},
        {{BINxOP,"+"},{SIMPLExVAR,"g"},{{BINxOP,"%"},{{UNxOP,"-"},
        {SIMPLExVAR,"h"}},{SIMPLExVAR,"i"}}}},{SIMPLExVAR,"j"}}}},
      "Complex expression: misc #3")
    checkParse(t, "x=a++(b*c<=d)- -e/(f>g+-h%i)>=j[-z]", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{{BINxOP,">="},
        {{BINxOP,"-"},{{BINxOP,"+"},{SIMPLExVAR,"a"},{{UNxOP,"+"},
        {{BINxOP,"<="},{{BINxOP,"*"},{SIMPLExVAR,"b"},{SIMPLExVAR,"c"}},
        {SIMPLExVAR,"d"}}}},{{BINxOP,"/"},{{UNxOP,"-"},
        {SIMPLExVAR,"e"}},{{BINxOP,">"},{SIMPLExVAR,"f"},{{BINxOP,"+"},
        {SIMPLExVAR,"g"},{{BINxOP,"%"},{{UNxOP,"-"},{SIMPLExVAR,"h"}},
        {SIMPLExVAR,"i"}}}}}},{ARRAYxVAR,"j",{{UNxOP,"-"},
        {SIMPLExVAR,"z"}}}}}},
      "Complex expression: misc #4")
    checkParse(t, "write(rand(read()==15e3),rand(rand(rand(read()))))",
      true, true,
     {STMTxLIST,{WRITExSTMT,{RANDxCALL,{{BINxOP,"=="},{READxCALL},
       {NUMLITxVAL,"15e3"}}},{RANDxCALL,{RANDxCALL,{RANDxCALL,
       {READxCALL}}}}}},
     "Complex expression with write")
    checkParse(t, "x=a==b+c*+d!=e-/-g<h+i%+j",
      false, false, nil,
      "Bad complex expression: misc #1")
    checkParse(t, "x=a==b+(c*+(d!=e-f/-g)<h+i)%+",
      false, true, nil,
      "Bad complex expression: misc #2")
    checkParse(t, "x=a++b*c<=d- -e x/f>g+-h%i>=j",
      false, false, nil,
      "Bad complex expression: misc #3")
    checkParse(t, "x=a++b*c<=d)- -e/(f>g+-h%i)>=j",
      true, false, nil,
      "Bad complex expression: misc #4")

    checkParse(t, "x=((a[(b[c[(d[((e[f]))])]])]))", true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{ARRAYxVAR,"a",
        {ARRAYxVAR,"b",{ARRAYxVAR,"c",{ARRAYxVAR,"d",{ARRAYxVAR,"e",
        {SIMPLExVAR,"f"}}}}}}}},
      "Complex expression: many parens/brackets")
    checkParse(t, "x=((a[(b[c[(d[((e[f]))]])])]))", false, false, nil,
      "Bad complex expression: mismatched parens/brackets")

    checkParse(t, "while(a+b)%d+a()!=true do write()end", true, true,
      {STMTxLIST,{WHILExLOOP,{{BINxOP,"!="},{{BINxOP,"+"},
        {{BINxOP,"%"},{{BINxOP,"+"},{SIMPLExVAR,"a"},{SIMPLExVAR,"b"}},
        {SIMPLExVAR,"d"}},{FUNCxCALL,"a"}},{BOOLLITxVAL,"true"}},
        {STMTxLIST,{WRITExSTMT}}}},
      "While loop with complex expression")
    checkParse(t, "if 6e+5==true/((q()))+-+-+-false then a=3elseif"
      .." 3+4+5then x=5else r=7end", true, true,
      {STMTxLIST,{IFxSTMT,{{BINxOP,"=="},{NUMLITxVAL,"6e+5"},{{BINxOP,
        "+"},{{BINxOP,"/"},{BOOLLITxVAL,"true"},{FUNCxCALL,"q"}},
        {{UNxOP,"-"},{{UNxOP,"+"},{{UNxOP,"-"},{{UNxOP,"+"},{{UNxOP,
        "-"},{BOOLLITxVAL,"false"}}}}}}}},{STMTxLIST,{ASSNxSTMT,
        {SIMPLExVAR,"a"},{NUMLITxVAL,"3"}}},{{BINxOP,"+"},{{BINxOP,"+"},
        {NUMLITxVAL,"3"},{NUMLITxVAL,"4"}},{NUMLITxVAL,"5"}},{STMTxLIST,
        {ASSNxSTMT,{SIMPLExVAR,"x"},{NUMLITxVAL,"5"}}},{STMTxLIST,
        {ASSNxSTMT,{SIMPLExVAR,"r"},{NUMLITxVAL,"7"}}}}},
      "If statement with complex expression")
end


function test_prog(t)
    io.write("Test Suite: complete programs\n")

    -- Example #1 from Assignment 4 description
    checkParse(t,
      [[#!
        -- Maleo Example #1
        -- Glenn G. Chappell
        -- 2023-02-14
        x = 3  -- Set a variable
        write(x+4, cr)
      ]], true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"x"},{NUMLITxVAL,"3"}},
        {WRITExSTMT,{{BINxOP,"+"},{SIMPLExVAR,"x"},{NUMLITxVAL,"4"}},
        {CRxOUT}}},
      "Program: Example #1 from Assignment 4 description")

    -- Fibonacci Example
    checkParse(t,
      [[#!
      -- fibo.mal
      -- Glenn G. Chappell
      -- 2023-02-14
      --
      -- For CS 331 Spring 2023-02-14
      -- Compute Fibonacci Numbers


      -- The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
      -- F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


      -- fibo (param in variable n)
      -- Return Fibonacci number F(n).
      function fibo()
          -- Varibles holding consecutive Fibonacci numbers
          currfib = 0
          nextfib = 1

          -- Advance currfib, nextfib as many times as needed
          i = 0  -- Loop counter
          while i < n do
              tmp = currfib + nextfib
              currfib = nextfib
              nextfib = tmp
              i = i+1
          end
          return currfib
      end


      -- Main program
      -- Print some Fibonacci numbers, nicely formatted.
      how_many_to_print = 20

      write("Fibonacci Numbers", cr)

      j = 0  -- Loop counter
      while j < how_many_to_print do
          n = j  -- Set param for fibo
          ff = fibo()
          write("F(", j, ") = ", ff, cr)
          j = j+1
      end
      ]], true, true,
      {STMTxLIST,{FUNCxDEF,"fibo",{STMTxLIST,{ASSNxSTMT,
      {SIMPLExVAR,"currfib"},{NUMLITxVAL,"0"}},{ASSNxSTMT,
      {SIMPLExVAR,"nextfib"},{NUMLITxVAL,"1"}},{ASSNxSTMT,
      {SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},{WHILExLOOP,{{BINxOP,"<"},
      {SIMPLExVAR,"i"},{SIMPLExVAR,"n"}},{STMTxLIST,{ASSNxSTMT,
      {SIMPLExVAR,"tmp"},{{BINxOP,"+"},{SIMPLExVAR,"currfib"},
      {SIMPLExVAR,"nextfib"}}},{ASSNxSTMT,{SIMPLExVAR,"currfib"},
      {SIMPLExVAR,"nextfib"}},{ASSNxSTMT,{SIMPLExVAR,"nextfib"},
      {SIMPLExVAR,"tmp"}},{ASSNxSTMT,{SIMPLExVAR,"i"},{{BINxOP,"+"},
      {SIMPLExVAR,"i"},{NUMLITxVAL,"1"}}}}},{RETURNxSTMT,
      {SIMPLExVAR,"currfib"}}}},{ASSNxSTMT,
      {SIMPLExVAR,"how_many_to_print"},{NUMLITxVAL,"20"}},{WRITExSTMT,
      {STRLITxOUT,"\"Fibonacci Numbers\""},{CRxOUT}},{ASSNxSTMT,
      {SIMPLExVAR,"j"},{NUMLITxVAL,"0"}},{WHILExLOOP,{{BINxOP,"<"},
      {SIMPLExVAR,"j"},{SIMPLExVAR,"how_many_to_print"}},{STMTxLIST,
      {ASSNxSTMT,{SIMPLExVAR,"n"},{SIMPLExVAR,"j"}},{ASSNxSTMT,
      {SIMPLExVAR,"ff"},{FUNCxCALL,"fibo"}},{WRITExSTMT,
      {STRLITxOUT,"\"F(\""},{SIMPLExVAR,"j"},{STRLITxOUT,"\") = \""},
      {SIMPLExVAR,"ff"},{CRxOUT}},{ASSNxSTMT,{SIMPLExVAR,"j"},
      {{BINxOP,"+"},{SIMPLExVAR,"j"},{NUMLITxVAL,"1"}}}}}},
      "Program: Fibonacci Example")

    -- Input number, print its square
    checkParse(t,
      [[#!
        write("Type a number: ")
        a = read()
        write(cr, cr)
        write("You typed: ")
        write(a, cr)
        write("Its square is: ")
        write(a*a, cr, cr)
      ]], true, true,
      {STMTxLIST,{WRITExSTMT,{STRLITxOUT,"\"Type a number: \""}},
        {ASSNxSTMT,{SIMPLExVAR,"a"},{READxCALL}},{WRITExSTMT,
        {CRxOUT},{CRxOUT}},{WRITExSTMT,
        {STRLITxOUT,"\"You typed: \""}},{WRITExSTMT,{SIMPLExVAR,"a"},
        {CRxOUT}},{WRITExSTMT,
        {STRLITxOUT,"\"Its square is: \""}},{WRITExSTMT,{{BINxOP,"*"},
        {SIMPLExVAR,"a"},{SIMPLExVAR,"a"}},{CRxOUT},{CRxOUT}}},
      "Program: Input number, print its square")

    -- Input numbers, stop at sentinel, print even/odd
    checkParse(t,
      [[#!
        continue = true
        while continue do
            write("Type a number (0 to end): ")
            n = read()
            write(cr, cr)
            if (n == 0) then
                continue = false
            else
                write("The number ", n, " is ")
                if n % 2 == 0 then
                    write("even")
                else
                    write("odd")
                end
                write(cr, cr)
            end
        end
        write("Bye!", cr, cr)
      ]], true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"continue"},
      {BOOLLITxVAL,"true"}},{WHILExLOOP,{SIMPLExVAR,"continue"},
      {STMTxLIST,{WRITExSTMT,
      {STRLITxOUT,"\"Type a number (0 to end): \""}},{ASSNxSTMT,
      {SIMPLExVAR,"n"},{READxCALL}},{WRITExSTMT,{CRxOUT},{CRxOUT}},
      {IFxSTMT,{{BINxOP,"=="},{SIMPLExVAR,"n"},{NUMLITxVAL,"0"}},
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"continue"},
      {BOOLLITxVAL,"false"}}},{STMTxLIST,{WRITExSTMT,
      {STRLITxOUT,"\"The number \""},{SIMPLExVAR,"n"},
      {STRLITxOUT,"\" is \""}},{IFxSTMT,{{BINxOP,"=="},{{BINxOP,"%"},
      {SIMPLExVAR,"n"},{NUMLITxVAL,"2"}},{NUMLITxVAL,"0"}},{STMTxLIST,
      {WRITExSTMT,{STRLITxOUT,"\"even\""}}},{STMTxLIST,{WRITExSTMT,
      {STRLITxOUT,"\"odd\""}}}},{WRITExSTMT,{CRxOUT},{CRxOUT}}}}}},
      {WRITExSTMT,{STRLITxOUT,"\"Bye!\""},{CRxOUT},{CRxOUT}}},
      "Program: Input numbers, stop at sentinel, print even/odd")

    -- Input numbers, print them in reverse order
    checkParse(t,
      [[#!
        howMany = 5  -- How many numbers to input
        write("I will ask you for ", howMany, " numbers.", cr)
        write("Then I will print them in reverse order.", cr, cr)
        i = 1
        while i <= howMany do  -- Input loop
            write("Type value #", i, ": ")
            v[i] = read()
            write(cr, cr)
            i = i+1
        end
        write("------------------------------------", cr, cr)
        write("Here are the values, in reverse order:", cr)
        i = howMany
        while i > 0 do  -- Output loop
            write("Value #", i, ": ", v[i], cr)
            i = i-1
        end
        write(cr)
      ]], true, true,
      {STMTxLIST,{ASSNxSTMT,{SIMPLExVAR,"howMany"},{NUMLITxVAL,"5"}},
      {WRITExSTMT,{STRLITxOUT,"\"I will ask you for \""},
      {SIMPLExVAR,"howMany"},{STRLITxOUT,"\" numbers.\""},{CRxOUT}},
      {WRITExSTMT,
      {STRLITxOUT,"\"Then I will print them in reverse order.\""},
      {CRxOUT},{CRxOUT}},{ASSNxSTMT,{SIMPLExVAR,"i"},{NUMLITxVAL,"1"}},
      {WHILExLOOP,{{BINxOP,"<="},{SIMPLExVAR,"i"},
      {SIMPLExVAR,"howMany"}},{STMTxLIST,{WRITExSTMT,
      {STRLITxOUT,"\"Type value #\""},{SIMPLExVAR,"i"},
      {STRLITxOUT,"\": \""}},{ASSNxSTMT,{ARRAYxVAR,"v",
      {SIMPLExVAR,"i"}},{READxCALL}},{WRITExSTMT,{CRxOUT},{CRxOUT}},
      {ASSNxSTMT,{SIMPLExVAR,"i"},{{BINxOP,"+"},{SIMPLExVAR,"i"},
      {NUMLITxVAL,"1"}}}}},{WRITExSTMT,
      {STRLITxOUT,"\"------------------------------------\""},{CRxOUT},
      {CRxOUT}},{WRITExSTMT,
      {STRLITxOUT,"\"Here are the values, in reverse order:\""},
      {CRxOUT}},{ASSNxSTMT,{SIMPLExVAR,"i"},{SIMPLExVAR,"howMany"}},
      {WHILExLOOP,{{BINxOP,">"},{SIMPLExVAR,"i"},{NUMLITxVAL,"0"}},
      {STMTxLIST,{WRITExSTMT,{STRLITxOUT,"\"Value #\""},
      {SIMPLExVAR,"i"},{STRLITxOUT,"\": \""},{ARRAYxVAR,"v",
      {SIMPLExVAR,"i"}},{CRxOUT}},{ASSNxSTMT,{SIMPLExVAR,"i"},
      {{BINxOP,"-"},{SIMPLExVAR,"i"},{NUMLITxVAL,"1"}}}}},{WRITExSTMT,
      {CRxOUT}}},
      "Program: Input numbers, print them in reverse order")

    -- Long program
    howmany = 200
    progpiece = "write(42)"
    prog = progpiece:rep(howmany)
    ast = {STMTxLIST}
    astpiece = {WRITExSTMT,{NUMLITxVAL,"42"}}
    for i = 1, howmany do
        table.insert(ast, astpiece)
    end
    checkParse(t, prog, true, true,
      ast,
      "Program: Long program")

    -- Very long program
    howmany = 30000
    progpiece = "x = read() write(x, cr)"
    prog = progpiece:rep(howmany)
    ast = {STMTxLIST}
    astpiece1 = {ASSNxSTMT,{SIMPLExVAR,"x"},{READxCALL}}
    astpiece2 = {WRITExSTMT,{SIMPLExVAR,"x"},{CRxOUT}}
    for i = 1, howmany do
        table.insert(ast, astpiece1)
        table.insert(ast, astpiece2)
    end
    checkParse(t, prog, true, true,
      ast,
      "Program: Very long program")
end


function test_parseit(t)
    io.write("TEST SUITES FOR MODULE parseit\n")
    test_simple(t)
    test_write_stmt_no_expr(t)
    test_function_call_stmt(t)
    test_func_def_no_expr(t)
    test_while_loop_simple_expr(t)
    test_if_stmt_simple_expr(t)
    test_assn_stmt(t)
    test_return_stmt(t)
    test_write_stmt_with_expr(t)
    test_func_def_with_expr(t)
    test_expr_prec_assoc(t)
    test_read_rand(t)
    test_array_item(t)
    test_expr_complex(t)
    test_prog(t)
end


-- *********************************************************************
-- Main Program
-- *********************************************************************


test_parseit(tester)
io.write("\n")
endMessage(tester:allPassed())

-- Terminate program, signaling no error
terminate(0)

