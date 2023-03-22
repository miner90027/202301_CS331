#lang scheme
; check_scheme.scm
; Glenn G. Chappell
; 2023-03-22
;
; For CS 331 Spring 2023
; A Scheme Program to Run
; Used in Assignment 5, Exercise A


; Useful Functions

(define (a x y)
  (if (null? x)
      y
      (cons (car x) (a (cdr x) y)))
  )

(define (aa . xs)
  (if (null? xs)
      '()
      (a (car xs) (apply aa (cdr xs)))
      )
  )

(define (m d ns)
  (if (null? ns)
      '()
      (let ([n (+ d (car ns))])
        (cons (integer->char n) (m n (cdr ns))))
      )
  )

(define (mm ns) (list->string (m 0 ns)))


; Data

(define cds1 '(69 49 -17 13 7 -89 69 -4))
(define cds2 '(17 -6 -7 14 0 -83 69 7))
(define cds3 '(-7 11 -8 -7 13 6 -84 69))
(define cds4 '(-4 6 -2 13 -6 13 -89 69))
(define cds5 '(-4 19 -1 -83 69 9 -10 5))
(define cds6 '(13 -17 -69 69 -4 17 -6 13))
(define cds7 '(-89 69 -4 2 5 -72 69 17))
(define cds8 '(-17 9 -5 5 -7 -57))


; Output

(display "Secret message #4:\n\n")
(display (mm (aa cds1 cds2 cds3 cds4 cds5 cds6 cds7 cds8)))
(newline)
(newline)

