#lang racket
(require rackunit json github-api)

(provide check-jsexpr? check-status-code get-requests-remaining)
  
(define (check-jsexpr? v) (check-true (jsexpr? v)))

(define (check-status-code v status)
  (check-true (github-response? v))
  (check-eq? (github-response-code v) status))

(define (good-response? r)
  (or (= 200 (github-response-code r))
      (= 201 (github-response-code r))
      (= 204 (github-response-code r))))

(define (get-requests-remaining gh)
  (let ([resp (github-get-rate-limit gh)])
    (if (good-response? resp)
        (hash-ref (hash-ref (github-response-data resp) 'rate) 'remaining)
        0)))