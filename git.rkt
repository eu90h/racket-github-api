#lang racket
(provide
 (contract-out
  [github-get-blob (->* [github-api-req/c string? string? string?] [#:media-type string?] github-api-resp/c)]
  [github-create-blob (->* [github-api-req/c string? string? string?] [string? #:media-type string?] github-api-resp/c)]
  [github-get-commit (->* [github-api-req/c string? string? string?] [#:media-type string?] github-api-resp/c)]
  [github-create-commit (->* [github-api-req/c string? string? string? string? string?]
                             [#:media-type string? #:author string? #:email string? #:data string?]
                             github-api-resp/c)]))
(require json racket/list racket/string racket/contract "utils.rkt")
(define (github-get-blob api-req repo-owner repo sha #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/git/blobs/" sha)
           #:media-type media-type))

(define (github-create-blob api-req repo-owner repo content [encoding "utf-8"] #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/git/blobs")
           #:data (jsexpr->string
                   (make-hash (list (cons 'content content)
                                    (cons 'encoding encoding))))
           #:method "POST"
           #:media-type media-type))

(define (github-get-commit api-req repo-owner repo sha #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/git/commits/" sha)
              #:media-type media-type))

(define (github-create-commit api-req repo-owner repo message tree parents
                              #:media-type [media-type ""]
                              #:author [author ""]
                              #:email [email ""]
                              #:data [data ""])
  (let* ([commit-data (list (cons 'message message)
                                (cons 'tree tree)
                                (cons 'parents parents))]
         [author-data (if (equal? author "") null (cons 'name author))]
         [author-data (if (equal? email "") author-data (cons 'email email))]
         [author-data (if (equal? date "") author-data (cons 'date date))])
  (api-req (string-append "/repos/" repo-owner "/" repo "/git/commits")
              (jsexpr->string (make-hash (if (null? author-data)
                                             commit-data
                                             (append commit-data
                                                     (list (cons 'author author-data)))))))))
