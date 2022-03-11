#lang br

(require racket/draw)

(define (insert-expr drr-window)
  (define expr-string "@$  $@")
  (define editor (send drr-window get-definitions-text))
  (send editor insert expr-string)
  (define pos (send editor get-start-position))
  (send editor set-position (- pos 3)))

(define (draw-icon)
  (define target (make-bitmap 16 16))
  (define dc (new bitmap-dc% [bitmap target]))
  (send dc set-brush "ivory" 'solid)
  (send dc draw-rectangle 0 0 16 16)
  (send dc set-font (make-font #:size 7 #:family 'system
                             #:weight 'normal))
  (send dc set-text-foreground "sienna")
  (send dc draw-text "@$" 2 0)
  target)
(draw-icon)
  

(define our-jsonic-button
  (list
   "Insert expresson"
   (draw-icon)
   insert-expr
   #f))

  (provide button-list)
  (define button-list (list our-jsonic-button))