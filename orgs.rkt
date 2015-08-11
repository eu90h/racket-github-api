#lang racket

(provide 
 (contract-out
  [github-list-orgs (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-list-all-orgs (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-list-user-orgs (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-get-org (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-list-org-members (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]))
(require json racket/list racket/string racket/contract "utils.rkt")
(define (github-list-orgs api-req #:media-type [media-type ""])
  (api-req "/user/orgs" #:media-type media-type))

(define (github-list-all-orgs api-req #:media-type [media-type ""])
  (api-req "/organizations" #:media-type media-type))

(define (github-list-user-orgs api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user "/orgs") #:media-type media-type))

(define (github-get-org api-req org #:media-type [media-type ""])
  (api-req (string-append "/orgs/" org) #:media-type media-type))

(define (github-list-org-members api-req org #:media-type [media-type ""])
  (api-req (string-append "/orgs/" org "/members") #:media-type media-type))
