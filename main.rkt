#lang racket/base
(require net/http-client openssl net/base64 json racket/list racket/string racket/port racket/contract)

(define github-api-req/c (->* (string?) [string? string?] (or/c jsexpr? string?)))
(provide github-api-req/c
         github-fork-gist
         (contract-out
          [struct github-identity ([type symbol?] [data (listof string?)])]
          [github-api (-> github-identity? github-api-req/c)]
          [github-create-gist (->* (github-api-req/c list?) [string? boolean?] any/c)]
          [github-get-gist (-> github-api-req/c string? any/c)]
          [github-edit-gist (->* [github-api-req/c string? (listof pair?)] [string?] any/c)]))


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
                 (third (string-split (make-auth-header 'private-token (list a-username a-token)))))
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

;this is super ugly fix it!
(define (github-api id [endpoint "api.github.com"] [user-agent "racket/github-@eu90h"])
  (lambda (req [method "GET"] [data ""])
    (define-values (status-line header-list in-port) 
      (if (eq? "PUT" method) (http-sendrecv endpoint req
                                            #:ssl? (ssl-make-client-context 'auto)
                                            #:headers (list (make-auth-header (github-identity-type id)
                                                                              (github-identity-data id))
                                                            "Content-Length: 0"
                                                            "Accept: application/vnd.github.v3+json"
                                                            (string-append "User-Agent: " user-agent))
                                            
                                            #:method method)
          (if (equal? "" data) (http-sendrecv endpoint req
                                              #:ssl? (ssl-make-client-context 'auto)
                                              #:headers (list (make-auth-header (github-identity-type id)
                                                                                (github-identity-data id))
                                                              "Accept: application/vnd.github.v3+json"
                                                              (string-append "User-Agent: " user-agent))
                                              ;  #:data data
                                              #:method method)
              (http-sendrecv endpoint req
                             #:ssl? (ssl-make-client-context 'auto)
                             #:headers (list (make-auth-header (github-identity-type id)
                                                               (github-identity-data id))
                                             "Accept: application/vnd.github.v3+json"
                                             (string-append "User-Agent: " user-agent))
                             #:data data
                             #:method method))))
    (if (or (= 201 (get-status-code (bytes->string/utf-8 status-line)))
            (= 200 (get-status-code (bytes->string/utf-8 status-line))))
        (port->jsexpr in-port)
        (bytes->string/utf-8 status-line))))

(define (github-create-gist api-req files [d ""] [p #f])
  (define (hash-files files)
    (define tmp (map (lambda (file-data) (cons 'content (cdr file-data))) files))
    (define (loop i new-files)
      (if (>= i (length tmp)) new-files
          (loop (add1 i) (append new-files (list (cons (if (string? (car (list-ref files i))) (string->symbol (car (list-ref files i))) (car (list-ref files i))) (make-hash (list (list-ref tmp i)))))))))
    (make-hash (loop 0 null)))
  (define data (jsexpr->string (if (equal? "" d) (hasheq 'public p 'files (hash-files files))
                                   (hasheq 'description d
                                           'public p
                                           'files (hash-files files)))))
  (api-req "/gists" "POST" data))

(define (github-get-gist api-req gist-id)
  (api-req (string-append "/gists/" gist-id)))

(define (github-edit-gist api-req gist-id files [description ""])
  (define (hash-files files)
    (define updated-files (filter (lambda (file-data) (not (equal? (cdr file-data) null))) files))
    (define deleted-files (filter (lambda (file-data) (equal? (cdr file-data) null)) files))
    (define tmp (map (lambda (file-data) (cons 'content (cdr file-data))) updated-files))
    (define (loop i new-files)
      (if (>= i (length tmp)) new-files
          (loop (add1 i) (append new-files (list (cons (if (string? (car (list-ref updated-files i))) (string->symbol (car (list-ref updated-files i))) (car (list-ref updated-files i))) (make-hash (list (list-ref tmp i)))))))))
    (make-hash (append (loop 0 null)
                       (map (lambda (file-data) (cons (string->symbol (car file-data)) "null")) deleted-files))))
  (displayln (hash-files files))
  (define data (jsexpr->string (if (equal? "" description) (hasheq 'files (hash-files files))
                                   (hasheq 'description description
                                           'files (hash-files files)))))
  (api-req (string-append "/gists/" gist-id) "PATCH"  data))

(define (github-list-gist-commits api-req gist-id)
  (api-req (string-append "/gists/" gist-id "/commits")))

(define (github-star-gist api-req gist-id)
  (api-req (string-append "/gists/" gist-id "/star") "PUT"))

(define (github-unstar-gist api-req gist-id)
  (api-req (string-append "/gists/" gist-id "/star") "DELETE"))

(define (github-gist-starred? api-req gist-id)
  (equal? "204" (second (api-req (string-append "/gists/" gist-id "/star")))))

(define (github-fork-gist api-req gist-id)
  (api-req (string-append "/gists/" gist-id "/forks") "POST" "{}"))

(define (github-list-gist-forks api-req gist-id)
  (api-req (string-append "/gists/" gist-id "/forks")))

(define (github-delete-gist api-req gist-id)
  (api-req (string-append "/gists/" gist-id) "DELETE"))

(define (github-get-gist-revision api-req gist-id sha)
  (api-req (string-append "/gists/" gist-id "/" sha)))

(define (github-get-users-gists api-req username)
  (api-req (string-append "/users/" username "/gists")))

(define (github-get-my-gists api-req)
  (api-req "/gists"))

(define (github-get-my-starred-gists api-req)
  (api-req "/gists/starred"))

(define (github-get-all-public-gists api-req)
  (api-req "/gists/public"))
