#!/usr/bin/env lua
-- pa2_test.lua
-- Glenn G. Chappell
-- 2023-02-07
--
-- For CS 331 Spring 2023
-- Test Program for Assignment 2 Functions
-- Used in Assignment 2, Exercise B

pa2 = require "pa2"  -- Import pa2 module


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


-- max_table_items: maximum number of table items to print in error
-- messages
max_table_items = 20



-- *********************************************************************
-- Test Suite Functions
-- *********************************************************************


function test_mapTable(t)
    local function test(t, f, inv, expect, msg)
        local outv = pa2.mapTable(f, inv)
        local success = equal(outv, expect)
        t:test(success, msg)
        if not success then
            io.write("Expect: ")
            printValue(expect, max_table_items)
            io.write("\n")
            io.write("Actual: ")
            printValue(outv, max_table_items)
            io.write("\n")
            io.write("\n")
            failExit()
        end
    end

    io.write("Test Suite: mapTable\n")

    local inv, expect

    local function id(x)
        return x
    end

    local function sq(n)
        return n*n
    end

    local function strlen(s)
        return s:len()
    end

    local function xs(n)
        retval = ""
        for i = 1, n do
            retval = retval .. "x"
        end
        return retval
    end

    local function is5(x)
        return x == 5
    end

    inv = { }
    expect = inv
    test(t, id, inv, expect, "empty table")

    inv = { 2 }
    expect = { 2 }
    test(t, id, inv, expect, "singleton table, #1")

    inv = { ["hi"]=2 }
    expect = { ["hi"]=4 }
    test(t, sq, inv, expect, "singleton table, #2")

    inv = { [3]="abcd" }
    expect = { [3]=4 }
    test(t, strlen, inv, expect, "singleton table, #3")

    inv = { 3 }
    expect = { "xxx" }
    test(t, xs, inv, expect, "singleton table, #4")

    inv = { 5 }
    expect = { true }
    test(t, is5, inv, expect, "singleton table, #5")

    inv = { true, 2, [true]="xyz" }
    expect = inv
    test(t, id, inv, expect, "small table, #1")

    inv = { 20, -1, 37, [false]=4321 }
    expect = { 400, 1, 1369, [false]=18671041 }
    test(t, sq, inv, expect, "small table, #2")

    inv = { "My", "dog", "has", "globuliferous", "fleas" }
    expect = { 2, 3, 3, 13, 5 }
    test(t, strlen, inv, expect, "small table, #3")

    inv = { 10, 2, 1, 0 }
    expect = { "xxxxxxxxxx", "xx", "x", "" }
    test(t, xs, inv, expect, "small table, #4")

    inv = { 3, 5, "abc", true }
    expect = { false, true, false, false }
    test(t, is5, inv, expect, "small table, #5")

    inv = {}
    for i = 1, 10000 do
        table.insert(inv, 37)
        table.insert(inv, "abcd")
    end
    expect = inv
    test(t, id, inv, expect, "large table, #1")

    inv = {}
    expect = {}
    for i = 1, 10000 do
        table.insert(inv, 3)
        table.insert(expect, 9)
        table.insert(inv, -100)
        table.insert(expect, 10000)
    end
    test(t, sq, inv, expect, "large table, #2")

    inv = {}
    expect = {}
    for i = 1, 10000 do
        table.insert(inv, "x")
        table.insert(expect, 1)
        table.insert(inv, "This is a sentence." )
        table.insert(expect, 19)
    end
    test(t, strlen, inv, expect, "large table, #3")

    inv = {}
    expect = {}
    for i = 1, 10000 do
        table.insert(inv, 2)
        table.insert(expect, "xx")
        table.insert(inv, 5)
        table.insert(expect, "xxxxx")
    end
    test(t, xs, inv, expect, "large table, #4")

    inv = {}
    expect = {}
    for i = 1, 10000 do
        table.insert(inv, 5)
        table.insert(expect, true)
        table.insert(inv, "Howdy")
        table.insert(expect, false)
    end
    test(t, is5, inv, expect, "large table, #4")

end


function test_concatMax(t)
    local function test(t, ins, lim, expect, msg)
        local outs = pa2.concatMax(ins, lim)
        local success = outs == expect
        t:test(success, msg)
        if not success then
            io.write("Expect: "..expect.."\n")
            io.write("Actual: "..outs.."\n")
            io.write("\n")
            failExit()
        end
    end

    io.write("Test Suite: concatMax\n")

    local ins, expect

    ins = "a"
    expect = "aa"
    test(t, ins, 2, expect, "string of length 1, #1")
    expect = "aaaaaaaa"
    test(t, ins, 8, expect, "string of length 1, #2")
    expect = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    test(t, ins, 40, expect, "string of length 1, #3")

    ins="abcdefghijklmnop"
    expect=""
    test(t, ins, 0, expect, "string of length 16, #1")
    test(t, ins, 7, expect, "string of length 16, #2")
    test(t, ins, 15, expect, "string of length 16, #3")
    expect = ins
    test(t, ins, 16, expect, "string of length 16, #4")
    expect=ins..ins..ins..ins
    test(t, ins, 70, expect, "string of length 16, #5")
    test(t, ins, 78, expect, "string of length 16, #6")
    test(t, ins, 79, expect, "string of length 16, #7")
    expect=ins..ins..ins..ins..ins
    test(t, ins, 80, expect, "string of length 16, #8")
    test(t, ins, 81, expect, "string of length 16, #9")
end


function test_collatz(t)
    local function test(t, inv, expect)
        local outv = {}
        for val in pa2.collatz(inv) do
            outv[1+#outv] = val
        end
        local success = equal(outv, expect)
        t:test(success, "sequence starting at "..inv)
        if not success then
            io.write("Expect (yielded values): ")
            printArray(expect, max_table_items)
            io.write("\n")
            io.write("Actual (yielded values): ")
            printArray(outv, max_table_items)
            io.write("\n")
            io.write("\n")
            failExit()
        end
    end

    io.write("Test Suite: collatz\n")

    local inv, expect

    inv = 1
    expect = {1}
    test(t, inv, expect)

    inv = 2
    expect = {2,1}
    test(t, inv, expect)

    inv = 3
    expect = {3,10,5,16,8,4,2,1}
    test(t, inv, expect)

    inv = 4
    expect = {4,2,1}
    test(t, inv, expect)

    inv = 5
    expect = {5,16,8,4,2,1}
    test(t, inv, expect)

    inv = 9
    expect = {9,28,14,7,22,11,34,17,52,26,13,40,20,10,5,16,8,4,2,1}
    test(t, inv, expect)

    inv = 27
    expect = {27,82,41,124,62,31,94,47,142,71,214,107,322,161,484,242,
        121,364,182,91,274,137,412,206,103,310,155,466,233,700,350,175,
        526,263,790,395,1186,593,1780,890,445,1336,668,334,167,502,251,
        754,377,1132,566,283,850,425,1276,638,319,958,479,1438,719,2158,
        1079,3238,1619,4858,2429,7288,3644,1822,911,2734,1367,4102,2051,
        6154,3077,9232,4616,2308,1154,577,1732,866,433,1300,650,325,976,
        488,244,122,61,184,92,46,23,70,35,106,53,160,80,40,20,10,5,16,8,
        4,2,1}
    test(t, inv, expect)

    inv = 100
    expect = {100,50,25,76,38,19,58,29,88,44,22,11,34,17,52,26,13,40,20,
        10,5,16,8,4,2,1}
    test(t, inv, expect)
end


function test_backSubs(t)
    local function test(t, inv, expect)
        local outv = getCoroutineValues(pa2.backSubs, inv)
        local success = equal(outv, expect)
        t:test(success, 'backward substrings of "'..inv..'"')
        if not success then
            io.write("Expect (yielded values): ")
            printArray(expect)
            io.write("\n")
            io.write("Actual (yielded values): ")
            printArray(outv)
            io.write("\n")
            io.write("\n")
            failExit()
        end
    end

    io.write("Test Suite: backSubs\n")

    local inv, expect

    inv = ""
    expect = {""}
    test(t, inv, expect)

    inv = "x"
    expect = {"","x"}
    test(t, inv, expect)

    inv = "xy"
    expect = {"","y","x","yx"}
    test(t, inv, expect)

    inv = "abc"
    expect = {"","c","b","a","cb","ba","cba"}
    test(t, inv, expect)

    inv = "1211"
    expect = {"","1","1","2","1","11","12","21","112","121","1121"}
    test(t, inv, expect)

    inv = "abcd"
    expect = {"","d","c","b","a","dc","cb","ba","dcb","cba","dcba"}
    test(t, inv, expect)

    inv = "zzzzz"
    expect = {"","z","z","z","z","z","zz","zz","zz","zz","zzz","zzz",
              "zzz","zzzz","zzzz","zzzzz"}
    test(t, inv, expect)
end


function test_pa2(t)
    io.write("TEST SUITES FOR CS 331 ASSIGNMENT 2\n")
    test_mapTable(t)
    test_concatMax(t)
    test_collatz(t)
    test_backSubs(t)
end


-- *********************************************************************
-- Main Program
-- *********************************************************************


test_pa2(tester)
io.write("\n")
endMessage(tester:allPassed())

-- Terminate program, signaling no error
terminate(0)

