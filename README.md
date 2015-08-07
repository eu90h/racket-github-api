github-api
==========
Simple github api bindings.

Usage
=====
* First: `(require github-api)`
* Then create an identity: `(github-identity type data)`
* Finally, initiate the bindings: `(define github-api-req (github-api github-identity))`
* Now do your request: `(github-api-req "/users/plt/repos")`

For more detailed usage information and examples, see the included documentation.

Installation
============
Run `raco pkg install git://github.com/eu90h/racket-github-api` or use DrRacket.

