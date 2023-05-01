#lang scheme

#|
 | addpairs.scm
 | 2023/04/29
 | Spring 2023 CS 331
 | Assignment 7 Part 3
 |      A scheme procedure that adds pairs
 |          of numbers
 |#

(define (addpairs . args)
    (cond
        ; Check if current value is null
        ((null? args) args)
        ; Check if next value is null
        ((null? (cdr args)) args)
        ; Add the current value and the next value
        ;   then recurse over the rest of the values
        (else (cons(+ (car args) (cadr args)) (apply addpairs (cddr args))))
    )
)
