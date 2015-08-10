#lang racket
(require json "../main.rkt" "../../identity.rkt" rackunit "utils.rkt")

(define gh (github-api personal-token-id))

(define requests-remaining (get-requests-remaining gh))

(define (sub1-requests-remaining!)
  (begin (set! requests-remaining (sub1 requests-remaining))
         requests-remaining))

(define user "eu90h")
(define repo "api-test-repo")
(define issue-body "this is a test of the issues api")
(define issue-title "testing-issues-api")
(define issue-data (github-create-issue gh
                                       user
                                       repo
                                       issue-title
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

(check-equal? (hash-ref issue-data 'number)
              (hash-ref (github-get-issue gh user repo issue-number) 'number))
(sub1-requests-remaining!)

(define comment-body "have a tissue")
(define comment-data (github-create-comment gh
                                            user
                                            repo
                                            issue-number
                                            comment-body))
(check-equal? (hash-ref comment-data 'body) comment-body)
(sub1-requests-remaining!)

(define comment-id (hash-ref comment-data 'id))

(define new-comment-body "here's a thought: blah blah blah")
(define new-comment-data (github-edit-comment gh user repo comment-id new-comment-body))
(check-equal? (hash-ref new-comment-data 'body) new-comment-body)
(sub1-requests-remaining!)

(check-equal? (github-get-comment gh user repo comment-id) new-comment-data)
(sub1-requests-remaining!)

(check-status-code (github-delete-comment gh user repo comment-id) 204)
(sub1-requests-remaining!)

(check-equal? (hash-ref (github-edit-issue gh user repo issue-number #:state "closed") 'state) "closed")
(sub1-requests-remaining!)

(check-jsexpr? (github-list-issues gh user repo))
(sub1-requests-remaining!)