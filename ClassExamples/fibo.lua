#!/usr/bin/env lua
-- fibo.lua
-- Glenn G. Chappell
-- 2022-01-30
--
-- For CS F331 Spring 2023
-- Compute Fibonacci Numbers


-- The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
-- F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


-- fibo
-- Given n >= 0, return Fibonacci number F(n).
function fibo(n)
    -- Variables holding consecutive Fibonacci numbers
    local currfib, nextfib = 0, 1

    -- Advance currfib, nextfib as many times as needed
    for i = 1, n do
        currfib, nextfib = nextfib, currfib + nextfib
    end

    return currfib
end


-- Main program
-- Print some Fibonacci numbers, nicely formatted
how_many_to_print = 20

io.write("Fibonacci Numbers\n")
for i = 0, how_many_to_print-1 do
    io.write("F("..i..") = "..fibo(i).."\n")
end

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

