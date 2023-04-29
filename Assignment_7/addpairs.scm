#lang scheme

#|
 | addpairs.scm
 | 2023/04/29
 | Spring 2023 CS 331
 | Assignment 7 Part 3
 |      A scheme procedure that adds pairs
 |          of numbers.
 |#

(define (addpairs . args)
    (cond
        ((null? args) args)
        ((null? (cdr args)) args)
        (else (cons(+ (car args) (cadr args)) (apply addpairs (cddr args))))
    )
)
