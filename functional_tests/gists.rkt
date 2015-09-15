#lang racket
(require json github-api "identity.rkt" rackunit "utils.rkt")

(define gh (github-api personal-token-id))

(define requests-remaining (get-requests-remaining gh))

(define (sub1-requests-remaining!)
  (begin (set! requests-remaining (sub1 requests-remaining))
         requests-remaining))

(define new-gist (github-create-gist gh
                                          (list (cons "file1.txt" "this is a test"))
                                          #:description "a test gist"))
(define new-gist-data (github-response-data new-gist))
(define new-gist-id (hash-ref new-gist-data 'id))

(check-status-code (github-star-gist gh new-gist-id) 204)
(sub1-requests-remaining!)

(check-true (github-gist-starred? gh new-gist-id))
(sub1-requests-remaining!)

(check-status-code (github-unstar-gist gh new-gist-id) 204)
(sub1-requests-remaining!)

(check-false (github-gist-starred? gh new-gist-id))
(sub1-requests-remaining!)

(check-eq? (length (github-response-data (github-list-gist-commits gh new-gist-id))) 1)
(sub1-requests-remaining!)

(check-jsexpr? (github-response-data (github-edit-gist gh new-gist-id
                                 (list (cons "file1.txt" "new file contents"))
                                 #:description "testing gist edit")))
(sub1-requests-remaining!)

(check-equal? (hash-ref (github-response-data (github-fork-gist gh new-gist-id)) 'message)
              "You cannot fork your own gist.")
(sub1-requests-remaining!)

(check-equal? (github-response-data (github-list-gist-forks gh new-gist-id)) null) 
(sub1-requests-remaining!)

(check-status-code (github-delete-gist gh new-gist-id) 204)
(sub1-requests-remaining!)