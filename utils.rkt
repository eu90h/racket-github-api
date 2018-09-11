#lang racket
(define eof? ((curry equal?) eof))
(provide
 github-api-req/c
 github-api-resp/c
 (contract-out
  [struct github-identity ([type github-identity-type/c] [data (listof string?)])]
  [struct github-response ([code number?] [data jsexpr?])]
  [get-status-code (-> string? number?)]
  [make-auth-header (-> github-identity-type/c (listof string?) string?)]
  [port->jsexpr (-> input-port? jsexpr?)]
  [->string (-> any/c string?)]))

(require net/http-client openssl net/base64 json racket/list racket/string racket/port racket/contract)

(struct github-identity (type data))
(struct github-response (code data))
(define github-api-resp/c github-response?)
(define github-api-req/c (->* (string?) [#:method string? #:data string? #:media-type string?] github-api-resp/c))

(define github-identity-type/c
  (or/c 'password 'personal-token 'oauth2))

(module+ test (require rackunit))

(define (base64-encode-string s)
  (bytes->string/utf-8 (base64-encode (string->bytes/utf-8 s) "")))

(define base64-decode-string
  (compose bytes->string/utf-8 base64-decode string->bytes/utf-8))

(define (make-basic-auth-header username password)
  (unless (string? username)
    (raise-argument-error 'make-basic-auth-header "string?" username))
  (unless (string? password)
    (raise-argument-error 'make-basic-auth-header "string?" password))
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
  (unless (string? token) (raise-argument-error 'make-oauth2-header "string?" token))
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
  (unless (string? status-line) (raise-argument-error 'get-status-code "string?" status-line))
  (define parts (string-split status-line " "))
  (if (< (length parts) 2) 0
      (string->number (second parts))))

(define (->string v)
  (cond [(string? v) v]
        [(number? v) (number->string v)]
        [(symbol? v) (symbol->string v)]
        [(boolean? v) (if v "true" "false")]
        [(jsexpr? v) (jsexpr->string v)]
        [else ""]))

(define (port->jsexpr in)
  (unless (input-port? in)
    (raise-argument-error 'port->jsexpr "input-port?" in))
  (let ([data (port->string in)])
    (string->jsexpr (if (zero? (string-length data)) "{}"
                        data))))
(module+ test
  (check-true (jsexpr? (port->jsexpr (open-input-string ""))))
  (check-true (jsexpr? (port->jsexpr
                        (open-input-string "{\"test\": 3}")))))
