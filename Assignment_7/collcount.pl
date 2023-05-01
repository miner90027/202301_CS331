/*
 * collcount.pl
 * Aleks McCormick
 * 2023/04/29
 * Spring 2023 CS 331
 * Assignment 7 Exercise 4
 *   The same thing as Assignment 7 Exercise 2
 *      but written in Prolog
 */

% collcount\2
% collcount(+n, ?c)

%  Case when N is 1
collcount(1, 0). 

% Case when n is even
collcount(N, C) :-
    N > 1,              % Verify N > 1
    N mod 2 =:= 0,      % Verify N is even
    Nr is N / 2,        % Set Nr to N/2
    collcount(Nr, Cr),  % Recurse passing Nr and receiving Cr
    C is Cr + 1.        % Set C equal to Cr + 1 and return C

% Case when n is odd
collcount(N, C) :-
    N > 1,              % Verify N > 1
    N mod 2 =\= 0,      % Verify N is odd
    Nr is (3 * N + 1),  % Set Nr to 3N+1
    collcount(Nr, Cr),  % Recurse passing Nr and receiving Cr
    C is Cr + 1.        % Set C equal to Cr + 1 and return C
