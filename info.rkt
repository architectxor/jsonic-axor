#lang info


(define collection "jsonic") ;; virtous habit to specify it even if package name and collection are the same
(define version "1.0") ;; virtous habit to specify it
(define scribblings '(("scribblings/jsonic.scrbl"))) ;; tells where to find docs for package
(define test-omit-paths '("jsonic-test.rkt"
                          "indenter-test.rkt"
                          "jsonic-parser-test.rkt")) ;; skips this file tests
(define deps '("base"
               "beautiful-racket-lib"
               "brag-lib"
               "draw-lib"
               "gui-lib"
               "rackunit-lib"
               "syntax-color-lib"))
(define build-deps '("racket-doc"
                     "scribble-lib"))
