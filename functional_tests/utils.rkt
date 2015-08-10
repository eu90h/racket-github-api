#lang racket
(require rackunit json github-api)

(provide check-jsexpr? check-status-code get-requests-remaining)
  
(define (check-jsexpr? v) (check-true (jsexpr? v)))

(define (check-status-code v status)
  (check-eq? (get-status-code v) status))

(define (get-requests-remaining gh)
  (hash-ref (hash-ref (github-get-rate-limit gh) 'rate) 'remaining))