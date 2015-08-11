#lang racket
(provide
 (contract-out
   [github-list-public-events (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
   [github-list-events (->* [github-api-req/c  string? string?] [#:media-type string?] github-api-resp/c)]
   [github-list-issue-events (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
   [github-list-public-org-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
   [github-list-user-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
   [github-list-user-received-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
   [github-list-user-public-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
   [github-list-feeds (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
   [github-list-notifications (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]))

(require json racket/list racket/string racket/contract "utils.rkt")

(define (github-list-public-events api-req #:media-type [media-type ""])
  (api-req "/events" #:media-type media-type))

(define (github-list-events api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/events")
           #:media-type media-type))

(define (github-list-issue-events api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/events")
           #:media-type media-type))

(define (github-list-public-org-events api-req org #:media-type [media-type ""])
  (api-req (string-append "/orgs/" org "/events")
           #:media-type media-type))

(define (github-list-user-received-events api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user "/received_events")
           #:media-type media-type))

(define (github-list-user-received-public-events api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user "/received_events/public")
           #:media-type media-type))

(define (github-list-user-events api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user "/events")
           #:media-type media-type))

(define (github-list-user-public-events api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user "/events/public")
           #:media-type media-type))

(define (github-list-feeds api-req #:media-type [media-type ""])
  (api-req "/feeds" #:media-type media-type))

(define (github-list-notifications api-req #:media-type [media-type ""])
  (api-req "/notifications" #:media-type media-type))
