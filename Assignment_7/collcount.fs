( - 
  - collcount.fs
  - Aleks McCormick
  - 2023/04/28
  - Spring 2023 CS 331
  - Assignment 7 Exersize 2
  -   Takes in a number and returns the 
  -      number of itterations of the Collatz
- )

\ collcount
\ Takes a positive integer and returns the number of iterations
\       of the Collatz function required to take the input value
\       to 1
: collcount { n -- c }
    0
    begin
    n 1 > while
        n 2 mod 0 = if
            n 2 / to n
        else
            3 n * 1 + to n 
        endif    
        1 +
    
    repeat
;    

