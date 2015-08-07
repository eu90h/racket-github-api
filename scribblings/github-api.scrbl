#lang scribble/manual
@require[@for-label[github-api
                    racket/base]]

@title{github-api}
@author{eu90h}

@defmodule[github-api]
github-api a very thin wrapper for easily making requests to the github api, without dealing with
building headers, etc.

Before you begin making requests to the github api, you must create an identity.
@defstruct[github-identity ([type symbol?] [data list?])]{
 This struct holds your github identity.

 @racket[type] must be one of the following symbols: @racket['password 'personal-access-token 'oauth]
 
 @racket['password] authentication
 simply uses your github username and password.

 @racket['personal-access-token] authentication allows you
 to send your github username and a personal access token (created on your github settings page.)

 @racket['oauth] uses an OAuth token for authorization.
 
 For more information, see the @(hyperlink "https://developer.github.com/v3/auth/#basic-authentication"
                                           "github api documentation")

 The @racket[data] field is a list whose contents are determined by user authentication method.

 For @racket['password] or @racket['personal-access-token] types,
 your data will be of the form @racket[(list username password-or-token)],
 where both @racket[username] & @racket[password-or-token] are strings.

 For @racket['oauth], the data will simply be @racket[(list oauth-token)], where @racket[oauth-token]
 is a string.

 
}
@defform[(github-api-get/c (-> string? (or/c jsexpr? string?)))]{
This is a contract for the procedures returned by the function @racket[github-api].
These functions are called with an api request and return a @racket[jsexpr?] on a valid request,
or an HTTP status code string on failure.
}
@defproc*[([(github-api [identity github-identity?])
         (github-api-get/c)]
           [(github-api [identity github-identity?] [endpoint string?])
         (github-api-get/c)])]{
 Once you've created an identity, apply it to this procedure to receive a
 function for making api requests.}

@section{Example}
@racketblock[
 (require github-api)
 (define private-token "fs52knf535djbfk2je43b2436")
 (define username "alice")
 (define id (github-identity 'private-token (list username private-token)))
 
 (define github-req (github-api id))
 (github-req "/users/plt/repos")
 ]