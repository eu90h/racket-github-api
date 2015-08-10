#lang racket
(require rackunit json github-api)

(provide check-jsexpr? check-status-code)
  
(define (check-jsexpr? v) (check-true (jsexpr? v)))

(define (check-status-code v status)
  (check-eq? (get-status-code v) status))