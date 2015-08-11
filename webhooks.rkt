#lang racket
(provide 
 (contract-out
  [github-build-webhook-config (->* [string?]
                                    [#:content-type string? #:secret string? #:insecure-ssl string?]
                                    jsexpr?)]
  [github-hook-repo (->* [github-api-req/c string? string? string? jsexpr?]
                         [#:events list? #:active boolean?]
                         github-api-resp/c)]
  [github-test-push-hook (->* [github-api-req/c string? string? (or/c number? string?)] github-api-resp/c)]
  [github-ping-hook (->* [github-api-req/c string? string? (or/c number? string?)] github-api-resp/c)]
  [github-delete-hook (->* [github-api-req/c string? string? (or/c number? string?)] github-api-resp/c)]
  [github-get-hooks (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
  [github-get-hook (->* [github-api-req/c string? string? (or/c number? string?)] [#:media-type string?] github-api-resp/c)]))

(require json racket/list racket/string racket/contract "utils.rkt")

(define (github-build-webhook-config url
                                     #:content-type [content-type "form"]
                                     #:secret [secret ""]
                                     #:insecure-ssl [insecure-ssl "0"])
  (let* ([config-data (list (cons 'url url) (cons 'insecure_ssl insecure-ssl) (cons 'content_type content-type))]
         [config-data (if (equal? secret "") config-data (append config-data (list (cons 'secret secret))))])
    (make-hash config-data)))

(define (github-hook-repo api-req repo-owner repo name config
                          #:events [events (list "push")]
                          #:active [active #t])
  (let* ([data (list (cons 'name name)
                     (cons 'config config)
                     (cons 'events events)
                     (cons 'active active))])
    (api-req (string-append "/repos/" repo-owner "/" repo "/hooks")
             #:method "POST"
             #:data (jsexpr->string (make-hash data)))))

(define (github-get-hooks api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks")
           #:media-type media-type))

(define (github-get-hook api-req repo-owner repo hook-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" (->string hook-id))
           #:media-type media-type))

(define (github-test-push-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" (->string hook-id) "/tests")
           #:method "POST"))

(define (github-ping-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" (->string hook-id) "/pings")
           #:method "POST"))

(define (github-delete-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" (->string hook-id))
           #:method "DELETE"))