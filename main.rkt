#lang racket/base

(require net/http-client openssl json racket/list racket/string racket/port racket/contract
         "utils.rkt" "gists.rkt" "users.rkt" "orgs.rkt" "pull.rkt" "git.rkt" "webhooks.rkt"
         "issues.rkt" "events.rkt")

(provide
 (all-from-out "utils.rkt" "gists.rkt" "users.rkt" "orgs.rkt"
               "pull.rkt" "git.rkt" "webhooks.rkt" "issues.rkt" "events.rkt"))
(provide 
 (contract-out
  [github-api (->* [github-identity?] [#:endpoint string? #:user-agent string?] github-api-req/c)]
  [github-get-rate-limit (-> github-api-req/c jsexpr?)]))

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

(define (github-get-rate-limit api-req)
  (api-req "/rate_limit"))