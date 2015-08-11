#lang racket
(provide
 (contract-out
  [github-edit-issue (->* [github-api-req/c string? string? (or/c string? number?)]
                                      [#:title string? 
                                               #:body string?
                                               #:assignee string? 
                                               #:state string? 
                                               #:milestone number? 
                                               #:labels (listof string?)]
                                      jsexpr?)]
  [github-create-issue (->* [github-api-req/c string? string? string?]
                                    [#:body string?
                                            #:assignee string?
                                            #:milestone number? 
                                            #:labels (listof string?)]
                                    jsexpr?)]
  [github-list-all-issues (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-list-my-issues (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
  [github-list-org-issues (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
  [github-list-issues (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
  [github-get-issue (->* [github-api-req/c string? string? (or/c number? string?)] [#:media-type string?] github-api-resp/c)]
  [github-list-assignees (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
  [github-check-assignee (->* [github-api-req/c string? string? string?] [#:media-type string?] github-api-resp/c)]
  [github-list-issue-comments (->* [github-api-req/c string? string? (or/c number? string?)] [#:media-type string?] github-api-resp/c)]
  [github-list-comments (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
  [github-get-comment (->* [github-api-req/c string? string? (or/c number? string?)] [#:media-type string?] github-api-resp/c)]
  [github-create-comment (->* [github-api-req/c string? string? (or/c number? string?) string?] [#:media-type string?] github-api-resp/c)]
  [github-edit-comment (->* [github-api-req/c string? string? (or/c number? string?) string?] [#:media-type string?] github-api-resp/c)]
  [github-delete-comment (->* [github-api-req/c string? string? (or/c number? string?)] [#:media-type string?] github-api-resp/c)]))

(require json racket/list racket/string racket/contract "utils.rkt")

(define (github-list-all-issues api-req #:media-type [media-type ""])
  (api-req "/issues" #:media-type media-type))

(define (github-list-my-issues api-req #:media-type [media-type ""])
  (api-req "/user/issues" #:media-type media-type))

(define (github-list-org-issues api-req org #:media-type [media-type ""])
  (api-req (string-append "/orgs/" org "/issues")
           #:media-type media-type))

(define (github-list-issues api-req owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" owner "/" repo "/issues")
           #:media-type media-type))

(define (github-get-issue api-req owner repo issue-number #:media-type [media-type ""])
  (api-req (string-append "/repos/" owner "/" repo "/issues/" (->string issue-number))
           #:media-type media-type))

(define (github-create-issue api-req owner repo title #:body [body ""] #:assignee [assignee ""] #:milestone [milestone ""] #:labels [labels null] #:media-type [media-type ""])
  (let* ([data (list (cons 'title title))]
         [data (if (equal? "" body) data (append data (list (cons 'body body))))]
         [data (if (equal? "" assignee) data (append data (list (cons 'assignee assignee))))]
         [data (if (equal? "" milestone) data (append data (list (cons 'milestone milestone))))]
         [data (if (null? labels) data (append data (list (cons 'labels labels))))])
    (api-req (string-append "/repos/" owner "/" repo "/issues")
             #:method "POST"
             #:data (jsexpr->string (make-hash data))
             #:media-type media-type)))

(define (github-edit-issue api-req owner repo issue-number #:title [title ""] #:body [body ""] #:assignee [assignee ""] #:state [state ""] #:milestone [milestone ""] #:labels [labels null] #:media-type [media-type ""])
  (let* ([data null]
         [data (if (equal? "" title) data (list (cons 'title title)))]
         [data (if (equal? "" body) data (append data (list (cons 'body body))))]
         [data (if (equal? "" assignee) data (append data (list (cons 'assignee assignee))))]
         [data (if (equal? "" state) data (append data (list (cons 'state state))))]
         [data (if (equal? "" milestone) data (append data (list (cons 'milestone milestone))))]
         [data (if (null? labels) data (append data (list (cons 'labels labels))))])
    (api-req (string-append "/repos/" owner "/" repo "/issues/" (->string issue-number))
             #:method "PATCH"
             #:data (jsexpr->string (make-hash data))
             #:media-type media-type)))

(define (github-list-assignees api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/assignees") #:media-type media-type))

(define (github-check-assignee api-req repo-owner repo assignee #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/" assignee) #:media-type media-type))

(define (github-list-issue-comments api-req repo-owner repo issue-number #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/" (->string issue-number) "/comments") #:media-type media-type))

(define (github-list-comments api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments") #:media-type media-type))

(define (github-get-comment api-req repo-owner repo comment-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" (->string comment-id)) #:media-type media-type))

(define (github-create-comment api-req repo-owner repo issue-number comment-body #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/" (->string issue-number) "/comments")
           #:method "POST"
           #:data (jsexpr->string (make-hash (list (cons 'body comment-body))))))

(define (github-edit-comment api-req repo-owner repo comment-id comment-body #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" (->string comment-id))
           #:method "PATCH"
           #:data (jsexpr->string (make-hash (list (cons 'body comment-body))))))

(define (github-delete-comment api-req repo-owner repo comment-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" (->string comment-id))
           #:method "DELETE"))