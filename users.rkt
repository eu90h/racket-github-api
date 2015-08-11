#lang racket

(provide 
 (contract-out
  [github-get-user (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-get-authenticated-user (->* [github-api-req/c] github-api-resp/c)]
  [github-get-all-users (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]))
(require json racket/list racket/string racket/contract "utils.rkt")
(define (github-get-user api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user) #:media-type media-type))

(define (github-get-authenticated-user api-req)
  (api-req "/user"))

(define (github-get-all-users api-req #:media-type [media-type ""])
  (api-req "/users" #:media-type media-type))