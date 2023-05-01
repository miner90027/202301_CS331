( - 
  - collcount.fs
  - Aleks McCormick
  - 2023/04/28
  - Spring 2023 CS 331
  - Assignment 7 Exercise 2
  -   The same thing as the collatzCounts function from
  -      Assignment 5, but this time writen in Forth
  - )

\ collcount
\ Takes a positive integer and returns the number of iterations
\       of the Collatz function required to take the input value
\       to 1
: collcount { n -- c }
    0
    begin
    \ loop based collatz function
    n 1 > while
        n 2 mod 0 = if
            n 2 / to n
        else
            3 n * 1 + to n 
        endif
        \ Increment counter variable c
        1 +
    repeat
;    

