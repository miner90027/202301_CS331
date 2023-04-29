/*
 * collcount.pl
 * Aleks McCormick
 * 2023/04/29
 * Spring 2023 CS 331
 * Assignment 7 Part 4
 * 
 */

%  
collcount(1, 0). 

% Case when n is even
%   when n is even c is n/2
collcount(N, C) :-
    N > 1,
    N mod 2 =:= 0,
    Nr is N / 2,
    collcount(Nr, Cr),
    C is Cr + 1.

% Case when n is odd
collcount(N, C) :-
    N > 1,
    N mod 2 =\= 0,
    Nr is (3 * N + 1),
    collcount(Nr, Cr),
    C is Cr + 1.
