#lang racket/base
(require net/http-client openssl net/base64 json racket/list racket/string racket/port racket/contract)

(define github-api-resp/c (or/c jsexpr? string?))
(define github-api-req/c (->* (string?) [#:method string? #:data string? #:media-type string?] github-api-resp/c))
(provide github-api-req/c
         github-api-resp/c
         github-create-issue
         github-edit-issue
         (contract-out
          [struct github-identity ([type symbol?] [data (listof string?)])]
          [github-api (->* [github-identity?] [#:endpoint string? #:user-agent string?] github-api-req/c)]
          [get-status-code (-> string? string?)]
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
          [github-get-all-public-gists (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-public-events (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-repo-events (->* [github-api-req/c  string? string?] [#:media-type string?] github-api-resp/c)]
          [github-list-repo-issue-events (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
          [github-list-public-org-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
          [github-list-user-received-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
          [github-list-user-public-events (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
          [github-list-feeds (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-notifications (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-issues (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-my-issues (->* [github-api-req/c] [#:media-type string?] github-api-resp/c)]
          [github-list-org-issues (->* [github-api-req/c string?] [#:media-type string?] github-api-resp/c)]
          [github-list-repo-issues (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]
          [github-get-repo-issue (->* [github-api-req/c string? string? string?] [#:media-type string?] github-api-resp/c)]
          
          [github-list-repo-assignees (->* [github-api-req/c string? string?] [#:media-type string?] github-api-resp/c)]

          ;[github- (->* github-api-req/c [#:media-type string?] github-api-resp/c)]
          ))

(module+ test (require rackunit))

(define (base64-encode-string s)
  (bytes->string/utf-8 (base64-encode (string->bytes/utf-8 s) "")))

(define base64-decode-string
  (compose bytes->string/utf-8 base64-decode string->bytes/utf-8))

(define (make-basic-auth-header username password)
  (unless (string? username)
    (error "username must be a string"))
  
  (unless (string? password)
    (error "password must be a string"))
  
  (string-append "Authorization: Basic "
                 (base64-encode-string (string-append username ":" password))))

(module+ test
  ; List -> Any
  ; returns a random element of a list
  (define (random-element list) 
    (when (list? list) 
      (if (null? list) null (list-ref list (random (length list))))))
  
  (define (random-alphanumeric-char)
    (random-element
     (list #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
           #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z
           #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0)))
  
  (define (random-token [max 40]) (let loop ([i 0] [s ""])
                         (if (= i max) s (loop (add1 i) (string-append s (string (random-alphanumeric-char)))))))
  (define a-token (random-token))
  (define a-username (random-element (list "anna" "bob")))
  (check-equal? (base64-decode-string
                 (third (string-split (make-basic-auth-header a-username a-token) " ")))
                (string-append a-username ":" a-token)))

(define (make-oauth2-header token)
  (unless (string? token) (error "oauth token must be a string"))
  (string-append "Authorization: token " token))

(module+ test
  (check-equal? (string-append "Authorization: token " a-token)
                (make-oauth2-header a-token)))

(define (make-auth-header type args)
  (case type
    [(password personal-token) (make-basic-auth-header (first args) (second args))]
    [(oauth2) (make-oauth2-header (first args))]))

(module+ test
  (define a-password (random-token 8))
  (check-equal? (base64-decode-string
                 (third (string-split (make-auth-header 'password (list a-username a-password)))))
                (string-append a-username ":" a-password))
  (check-equal? (base64-decode-string
                 (third (string-split (make-auth-header 'personal-token (list a-username a-token)))))
                (string-append a-username ":" a-token))
  (check-equal? (third (string-split (make-auth-header 'oauth2 (list a-token))))
                a-token))

(define (get-status-code status-line)
  (unless (string? status-line) (error "status-line must be a string"))
  (define parts (string-split status-line " "))
  (when (< (length parts) 2) (error (string-append "malformed status-line: " status-line)))
  (string->number (second parts)))

(define port->jsexpr (compose string->jsexpr port->string))

(struct github-identity (type data))

(define (github-api id #:endpoint [endpoint "api.github.com"] #:user-agent [user-agent "racket-github-api-@eu90h"])
  (lambda (req #:method [method "GET"] #:data [data ""] #:media-type [media-type ""])
    (define-values (status-line header-list in-port)
      (let* ([headers (list (make-auth-header (github-identity-type id)
                                              (github-identity-data id))
                           (string-append "Accept: " (if (equal? media-type "") "application/vnd.github.v3+json" media-type))
                           (string-append "User-Agent: " user-agent))])
        (if (equal? data "") (http-sendrecv endpoint req #:ssl? (ssl-make-client-context 'auto)
                                                  #:headers headers
                                                  #:method method)
                                                  
            (http-sendrecv endpoint req #:ssl? (ssl-make-client-context 'auto)
                           #:headers (if (eq? "PUT" method) (append headers (list "Content-Length: 0")) headers)
                           #:method method
                           #:data data))))

    (if (or (= 201 (get-status-code (bytes->string/utf-8 status-line)))
            (= 200 (get-status-code (bytes->string/utf-8 status-line)))
            (= 422 (get-status-code (bytes->string/utf-8 status-line))))
        (port->jsexpr in-port)
        (bytes->string/utf-8 status-line))))

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
  (equal? "204" (second (string-split (api-req (string-append "/gists/" gist-id "/star") #:media-type media-type) " "))))

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

(define (github-list-public-events api-req #:media-type [media-type ""])
  (api-req "/events" #:media-type media-type))

(define (github-list-repo-events api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/events")
           #:media-type media-type))

(define (github-list-repo-issue-events api-req repo-owner repo #:media-type [media-type ""])
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

(define (github-list-issues api-req #:media-type [media-type ""])
  (api-req "/issues" #:media-type media-type))

(define (github-list-my-issues api-req #:media-type [media-type ""])
  (api-req "/user/issues" #:media-type media-type))

(define (github-list-org-issues api-req org #:media-type [media-type ""])
  (api-req (string-append "/orgs/" org "/issues")
           #:media-type media-type))

(define (github-list-repo-issues api-req owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" owner "/" repo "/issues")
           #:media-type media-type))

(define (github-get-repo-issue api-req owner repo issue-number #:media-type [media-type ""])
  (api-req (string-append "/repos/" owner "/" repo "/issues/" issue-number)
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

(define (github-edit-issue api-req owner repo #:title [title ""] #:body [body ""] #:assignee [assignee ""] #:state [state ""] #:milestone [milestone ""] #:labels [labels null] #:media-type [media-type ""])
  (let* ([data null]
         [data (if (equal? title) data (list (cons 'title title)))]
         [data (if (equal? "" body) data (append data (list (cons 'body body))))]
         [data (if (equal? "" assignee) data (append data (list (cons 'assignee assignee))))]
         [data (if (equal? "" state) data (append data (list (cons 'state state))))]
         [data (if (equal? "" milestone) data (append data (list (cons 'milestone milestone))))]
         [data (if (null? labels) data (append data (list (cons 'labels labels))))])
    (api-req (string-append "/repos/" owner "/" repo "/issues")
             #:method "POST"
             #:data (jsexpr->string (make-hash data))
             #:media-type media-type)))

(define (github-list-repo-assignees api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/assignees") #:media-type media-type))

(define (github-check-assignee api-req repo-owner repo assignee #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/" assignee) #:media-type media-type))

(define (github-list-issue-comments api-req repo-owner repo issue-number #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/" issue-number "/comments") #:media-type media-type))

(define (github-list-repo-comments api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments") #:media-type media-type))

(define (github-get-single-comment api-req repo-owner repo comment-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" comment-id) #:media-type media-type))

(define (github-create-comment api-req repo-owner repo issue-number comment-body #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/" issue-number "/comments")
           #:method "POST"
           #:data (jsexpr->string (make-hash (list (cons 'body comment-body))))))

(define (github-edit-comment api-req repo-owner repo comment-id comment-body #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" comment-id)
           #:method "PATCH"
           #:data (jsexpr->string (make-hash (list (cons 'body comment-body))))))

(define (github-delete-comment api-req repo-owner repo comment-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/issues/comments/" comment-id)
           #:method "DELETE"))

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

(define (github-list-pull-requests api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/pulls") #:media-type media-type))

(define (github-get-user api-req user #:media-type [media-type ""])
  (api-req (string-append "/users/" user) #:media-type media-type))

(define (github-get-authenticated-user api-req)
  (api-req "/user"))

(define (github-get-all-users api-req #:media-type [media-type ""])
  (api-req "/users" #:media-type media-type))

(provide github-build-webhook-config github-hook-repo)
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

(provide github-get-hooks)
(define (github-get-hooks api-req repo-owner repo #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks")
           #:media-type media-type))

(define (github-get-hook api-req repo-owner repo hook-id #:media-type [media-type ""])
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" hook-id)
           #:media-type media-type))

(provide github-test-push-hook)
(define (github-test-push-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" hook-id "/tests")
           #:method "POST"))

(define (github-ping-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" hook-id "/pings")
           #:method "POST"))
(provide github-delete-hook)
(define (github-delete-hook api-req repo-owner repo hook-id)
  (api-req (string-append "/repos/" repo-owner "/" repo "/hooks/" hook-id)
           #:method "DELETE"))
