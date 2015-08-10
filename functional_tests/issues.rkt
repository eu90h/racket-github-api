#lang racket
(require json github-api "../../identity.rkt" rackunit "utils.rkt")

(define gh (github-api personal-token-id))

(define requests-remaining (get-requests-remaining gh))

(define (sub1-requests-remaining!)
  (begin (set! requests-remaining (sub1 requests-remaining))
         requests-remaining))

(define user "eu90h")
(define repo "api-test-repo")
(define issue-body "this is a test of the issues api")

(define issue-data (github-create-issue gh
                                       user
                                       repo
                                       "testing-issues-api"
                                       #:body issue-body
                                       #:assignee user
                                       #:labels (list "woo!" "test")))
(sub1-requests-remaining!)

(check-jsexpr? issue-data)
(check-equal? (hash-ref issue-data 'body)
              issue-body)
(check-true (number? (hash-ref issue-data 'id)))

(define issue-number (hash-ref issue-data 'number))

(check-equal? (github-list-issue-comments gh user repo issue-number) null)
(sub1-requests-remaining!)