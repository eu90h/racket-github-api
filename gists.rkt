#lang racket
(require json racket/list racket/string racket/contract "utils.rkt")
(provide
 (contract-out
  [github-create-gist (->* (github-api-req/c list?) [#:description string? #:public boolean? #:media-type string?] github-api-resp/c)]
  [github-get-gist (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-edit-gist (->* [github-api-req/c string? (listof pair?)] [#:description string? #:media-type string?] github-api-resp/c)]
  [github-delete-file-from-gist (->* [github-api-req/c string? string?] [#:media-type string?]github-api-resp/c)]
  [github-list-gist-commits (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-star-gist (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-unstar-gist (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-gist-starred? (->* [github-api-req/c string?] [#:media-type string?] boolean?)]               
  [github-fork-gist (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-list-gist-forks (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-delete-gist (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-get-gist-revision (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
  [github-get-user-gists (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-get-my-gists (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-get-my-starred-gists (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-get-all-public-gists (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]))

(define (github-create-gist api-req files #:description [description ""] #:public [public #f] #:media-type [media-type ""])
  (define (hash-files files)
    (define tmp (map (lambda (file-data) (cons 'content (cdr file-data))) files))
    (define (loop i new-files)
      (if (>= i (length tmp)) new-files
          (loop (add1 i) (append new-files (list (cons (if (string? (car (list-ref files i))) (string->symbol (car (list-ref files i))) (car (list-ref files i))) (make-hash (list (list-ref tmp i)))))))))
    (make-hash (loop 0 null)))
  (define data (jsexpr->string (if (equal? "" description) (hasheq 'public public 'files (hash-files files))
                                   (hasheq 'description description
                                           'public public
                                           'files (hash-files files)))))
  (api-req "/gists" #:method "POST" #:data data #:media-type media-type))

(define (github-get-gist api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id) #:media-type media-type))

(define (github-edit-gist api-req gist-id files #:description [description ""] #:media-type [media-type ""])
  (define (hash-files files)
    (define updated-files (filter (lambda (file-data) (not (equal? (cdr file-data) null))) files))
    (define deleted-files (filter (lambda (file-data) (equal? (cdr file-data) 'delete)) files))
    (define tmp (map (lambda (file-data) (cons 'content (cdr file-data))) updated-files))
    (define (loop i new-files)
      (if (>= i (length tmp)) new-files
          (loop (add1 i) (append new-files (list (cons (if (string? (car (list-ref updated-files i))) (string->symbol (car (list-ref updated-files i))) (car (list-ref updated-files i))) (make-hash (list (list-ref tmp i)))))))))
    (make-hash (append (loop 0 null)
                       (map (lambda (file-data) (cons (string->symbol (car file-data)) "null")) deleted-files))))
  (define data (jsexpr->string (if (equal? "" description) (hasheq 'files (hash-files files))
                                   (hasheq 'description description
                                           'files (hash-files files)))))
  (api-req (string-append "/gists/" gist-id) #:method "PATCH" #:data data #:media-type media-type))

(define (github-delete-file-from-gist api-req gist-id file #:media-type [media-type ""])
  (github-edit-gist api-req gist-id
                 (list (cons file 'delete))
                 #:media-type media-type))

(define (github-list-gist-commits api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/commits") #:media-type media-type))

(define (github-star-gist api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/star") #:method "PUT" #:media-type media-type))

(define (github-unstar-gist api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/star")
           #:method "DELETE" #:media-type media-type))

(define (github-gist-starred? api-req gist-id #:media-type [media-type ""])
  (= 204
     (github-response-code 
      (api-req (string-append "/gists/" gist-id "/star")
               #:media-type media-type))))
                   

(define (github-fork-gist api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/forks")
           #:method "POST"
           #:media-type media-type))

(define (github-list-gist-forks api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/forks")
           #:media-type media-type))

(define (github-delete-gist api-req gist-id #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id)
           #:method "DELETE"
           #:media-type media-type))

(define (github-get-gist-revision api-req gist-id sha #:media-type [media-type ""])
  (api-req (string-append "/gists/" gist-id "/" sha)
           #:media-type media-type))

(define (github-get-user-gists api-req username #:media-type [media-type ""])
  (api-req (string-append "/users/" username "/gists")
           #:media-type media-type))

(define (github-get-my-gists api-req #:media-type [media-type ""])
  (api-req "/gists" #:media-type media-type))

(define (github-get-my-starred-gists api-req #:media-type [media-type ""])
  (api-req "/gists/starred" #:media-type media-type))

(define (github-get-all-public-gists api-req #:media-type [media-type ""])
  (api-req "/gists/public" #:media-type media-type))
