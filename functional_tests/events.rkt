#lang racket
(require json github-api "../../identity.rkt" rackunit "utils.rkt")

(define gh (github-api personal-token-id))

(define requests-remaining (get-requests-remaining gh))

(define (sub1-requests-remaining!)
  (begin (set! requests-remaining (sub1 requests-remaining))
         requests-remaining))

(let ([data (first (github-list-repo-events gh "eu90h" "racket-github-api"))])
  (sub1-requests-remaining!)
  (check-jsexpr? data)
  (check-equal? (hash-ref (hash-ref data 'repo) 'name) "eu90h/racket-github-api")
  (sub1-requests-remaining!))

(check-jsexpr? (github-list-user-events gh "eu90h"))
(sub1-requests-remaining!)