#!/usr/bin/env lua
-- useparseit.lua
-- Glenn G. Chappell
-- 2023-02-22
--
-- For CS 331 Spring 2023
-- Simple Main Program for parseit Module
-- Requires parseit.lua

parseit = require "parseit"


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
        if string.sub(x, 1, 1) == '"' then
            io.write("'"..x.."'")
        else
            io.write('"'..x..'"')
        end
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
        if not first then
            io.write(" ")
        end
        io.write("}")
    end
end


-- check
-- Given a "program", check its syntactic correctness using parseit.
-- Print results.
function check(program)
    dashstr = "-"
    io.write(dashstr:rep(72).."\n")
    io.write("Program: "..program.."\n")

    local good, done, ast = parseit.parse(program)
    assert(type(good) == "boolean")
    assert(type(done) == "boolean")
    if good then
        assert(type(ast) == "table")
    end

    if good and done then
        io.write("Good! - AST: ")
        printAST_parseit(ast)
        io.write("\n")
    elseif good and not done then
        io.write("Bad - extra characters at end\n")
    elseif not good and done then
        io.write("Unfinished - more is needed\n")
    else  -- not good and not done
        io.write("Bad - syntax error\n")
    end
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: Maleo\n")
check("")
check("write()")
check("write(cr)")
check("write(\"abc\",\"def\",cr)write('xyz')write(cr)")
check("function f()end")
check("function g()function h()end write(cr)write(cr)end write('y',cr)")
io.write("### All of the programs above will parse correcly with\n")
io.write("### parseit.lua as posted in the Git repository.\n")
io.write("### Those below may not (yet).\n")
check("a=3")
check("a=a+1")
check("a=read()")
check("write(a+1)")
check("a=3 write(a+b, cr)")
check("a[e*2+1]=2")
check("-- Maleo Example #1\n-- Glenn G. Chappell\n"..
      "-- 2023-02-14\nx = 3  -- Set a variable\nwrite(x, cr)\n")
io.write("### Above should be the AST given in the Assignment 4 "..
         "description,\n")
io.write("### under 'Introduction'\n")
check("write() elseif")
io.write("### Above should be ")
io.write("\"Bad - extra characters at end\"\n")
check("function foo() write(cr")
io.write("### Above should be ")
io.write("\"Unfinished - more is needed\"\n")
check("if a b")
io.write("### Above should be ")
io.write("\"Bad - syntax error\"\n")

