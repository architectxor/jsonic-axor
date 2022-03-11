#lang br
(require brag/support syntax-color/racket-lexer
         racket/contract)

(define jsonic-lexer
  (lexer
   [(eof) (values lexeme 'eof #f #f #f)]
   [(:or "@$" "$@")
    (values lexeme 'parenthesis
            (if (equal? lexeme "@$") '|(| '|)|)
            (pos lexeme-start) (pos lexeme-end))]
   [(from/to "//" "\n")
    (values lexeme 'comment #f
            (pos lexeme-start) (pos lexeme-end))]
   [any-char
    (values lexeme 'string #f
            (pos lexeme-start) (pos lexeme-end))]))

;; color-jsonic
;;   port: input port containing the source code
;;   offset: we don't use it
;;   racket-coloring-mode?: boolean value that represents if we use default racket colorer or not
(define (color-jsonic port offset racket-coloring-mode?)
  (cond
    [(or (not racket-coloring-mode?)
         (equal? (peek-string 2 0 port) "$@")) ;; if we look in port and see end of embedded S-expression, we 
     (define-values (str cat paren start end) (jsonic-lexer port)) ;; read color annotation
     (define switch-to-racket-mode (equal? str "@$")) ;; if matched lexeme is start of embedded S-expression we switch to default racket colorer
     (values str cat paren start end 0 switch-to-racket-mode)] ;; return new values
    ;; str is lexeme we matched
    ;; cat is category of source code chunk
    ;; paren is parenthesis type
    ;; start is start location
    ;; end is end location
    ;; 0 is backup distance we don't use it so we set it with 0
    ;; switch-to-racket-mode is boolean value which tells DrRacket which colorer to use
    [else (define-values (str cat paren start end) (racket-lexer port)) ;;<-- ITS RACKET LEXER NOT JSONIC LEXER
     (values str cat paren start end 0 #t)]))

(provide
 (contract-out
  [color-jsonic
   (-> input-port? exact-nonnegative-integer? boolean?
    (values
     (or/c string? eof-object?)
     symbol?
     (or/c symbol? #f)
     (or/c exact-nonnegative-integer? #f)
     (or/c exact-nonnegative-integer? #f)
     exact-nonnegative-integer?
     boolean?))]))


(module+ test
  (require rackunit)
  (check-equal? (values->list
                 (color-jsonic (open-input-string "x") 0 #f))
                (list "x" 'string #f 1 2 0 #f)))

