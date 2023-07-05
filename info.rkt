#lang info
(define collection "github-api")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/github-api.scrbl" () ("Git"))))
(define pkg-desc "bindings for the github api")
(define version "0.1")
(define pkg-authors '(eu90h))
