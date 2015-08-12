#lang racket
(require json "../main.rkt" "../../identity.rkt" rackunit "utils.rkt")

(define gh (github-api personal-token-id))

(define requests-remaining (get-requests-remaining gh))

(define (sub1-requests-remaining!)
  (begin (set! requests-remaining (sub1 requests-remaining))
         requests-remaining))

(define user "eu90h")
(define repo "api-test-repo")

(define config (github-build-webhook-config "http://example.com"
                                            #:insecure-ssl "0"
                                            #:content-type "json"))
(define hook (github-hook-repo gh user repo "web" config))
(define hook-data (github-response-data hook))
(sub1-requests-remaining!)

(check-jsexpr? hook-data)
(check-equal? (hash-ref hook-data 'name) "web")

(define hook-id (hash-ref hook-data 'id))
(let* ([resp (github-get-hooks gh user repo)]
       [resp-data (github-response-data resp)])
  (check-true (list? resp-data))
  (check-eq? (length resp-data) 1)
  (sub1-requests-remaining!))

(check-equal? (hash-ref (github-response-data (github-get-hook gh user repo hook-id)) 'url)
              (hash-ref hook-data 'url))
(sub1-requests-remaining!)

(check-status-code (github-test-push-hook gh user repo hook-id)
                   204)
(sub1-requests-remaining!)

(check-status-code (github-ping-hook gh user repo hook-id)
                   204)
(sub1-requests-remaining!)

(check-status-code (github-delete-hook gh user repo hook-id) 204)
(sub1-requests-remaining!)

(check-status-code  (github-delete-hook gh user repo hook-id) 404)
(sub1-requests-remaining!)