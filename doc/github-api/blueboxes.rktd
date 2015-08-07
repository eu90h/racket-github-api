512
((3) 0 () 2 ((q lib "github-api/main.rkt") (q 0 . 5)) () (h ! (equal) ((c def c (c (? . 0) q github-api)) q (208 . 6)) ((c def c (c (? . 0) q github-identity?)) c (? . 1)) ((c def c (c (? . 0) q github-identity-type)) c (? . 1)) ((c def c (c (? . 0) q github-identity-data)) c (? . 1)) ((c def c (c (? . 0) q struct:github-identity)) c (? . 1)) ((c def c (c (? . 0) q make-github-identity)) c (? . 1)) ((c form c (c (? . 0) q github-api-get/c)) q (141 . 2)) ((c def c (c (? . 0) q github-identity)) c (? . 1))))
struct
(struct github-identity (type data)
    #:extra-constructor-name make-github-identity)
  type : symbol?
  data : list?
syntax
(github-api-get/c (-> string? (or/c jsexpr? string?)))
procedure
(github-api identity) -> (github-api-get/c)
  identity : github-identity?
(github-api identity endpoint) -> (github-api-get/c)
  identity : github-identity?
  endpoint : string?
