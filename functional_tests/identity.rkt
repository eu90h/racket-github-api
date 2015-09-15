#lang racket

(provide (contract-out
          [personal-token-id github-identity?]
          [password-id github-identity?]))

(require github-api)

(define personal-token "your-token-here")
(define username "your-usernmae-here")
(define personal-token-id (github-identity 'personal-token (list username personal-token)))

(define password "")
(define password-id (github-identity 'password (list username password)))