#lang br
(require br/indent racket/contract racket/gui/base)

(define indent-width 2)
(define (left-bracket? c) (member c (list #\{ #\[)))
(define (right-bracket? c) (member c (list #\} #\])))

(define (indent-jsonic tbox [posn 0])
  (define prev-line (previous-line tbox posn))
  (define current-line (line tbox posn))
  (cond
    [(not prev-line) 0]
    [else
     (define prev-indent (line-indent tbox prev-line))
     (cond
       [(left-bracket?
         (line-first-visible-char tbox prev-line))
        (+ prev-indent
           (if (right-bracket? (char tbox (sub1 (line-end-visible tbox prev-line)))) 0 indent-width))]
       [(right-bracket?
         (line-first-visible-char tbox current-line))
        (- prev-indent indent-width)]
       [else prev-indent])]))
(provide
 (contract-out
  [indent-jsonic (((is-a?/c text%))
                  (exact-nonnegative-integer?) . ->* .
                  (or/c #f exact-nonnegative-integer?))]))

#;(provide indent-jsonic)

(module+ test
  (require rackunit)
  (define test-str #<<HERE
#lang jsonic
{
"value": 42,
"string":
[
{
"array": @$(range 5)$@,
"object": @$(hash 'k1 "valstring")$@
}
]
// "bar"
}
HERE
    )
  (check-equal?
   (string-indents (apply-indenter indent-jsonic test-str))
   '(0 0 2 2 2 4 6 6 4 2 2 0)))

#;(module+ test
  (define problem-str #<<TROUBLE
#lang jsonic

// line comment
[
 null,
 42,
 true,
 ["array", "of", "strings"],
 {
  "key-1": @$ (zero? (- 5 5)) $@,
  "key-2": false,
  "key-3": {"subkey": 21}
 }
]
TROUBLE
    )
  (displayln (apply-indenter indent-jsonic problem-str))
  (check-equal? (string-indents (apply-indenter indent-jsonic problem-str))
                '(0 0 0 0 2 2 2 2 2 4 4 4 2 0)))

