#lang racket
(provide 
 (contract-out
  [github-list-pull-requests (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]))

(require json racket/list racket/string racket/contract "utils.rkt")

(define (github-list-pull-requests api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/pulls") #:media-type media-type))
