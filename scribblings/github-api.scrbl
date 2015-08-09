#lang scribble/manual
@require[@for-label[github-api
                    racket/base]]

@title{github-api}
@author{eu90h}

@defmodule[github-api]
github-api is a wrapper for easily making requests to the GitHub api.

Before you begin making requests to the GitHub api, you must create an identity.
@section{Authentication & Initialization}

@defstruct[github-identity ([type symbol?] [data list?])]{
 This struct holds your GitHub identity.

 @racket[type] must be one of the following symbols: @racket['password 'personal-access-token 'oauth]
 
 @racket['password] authentication
 simply uses your GitHub username and password.

 @racket['personal-access-token] authentication allows you
 to send your GitHub username and a personal access token (created on your GitHub settings page.)

 @racket['oauth] uses an OAuth token for authorization.
 
 For more information, see the @(hyperlink "https://developer.github.com/v3/auth/#basic-authentication"
                                           "github api documentation")

 The @racket[data] field is a list whose contents are determined by user authentication method.

 For @racket['password] or @racket['personal-token] types,
 your data will be of the form @racket[(list username password-or-token)],
 where both @racket[username] & @racket[password-or-token] are strings.

 For @racket['oauth], the data will simply be @racket[(list oauth-token)], where @racket[oauth-token]
 is a string.
}
@defproc[(github-api [id github-identity?]
                     [#:endpoint endpoint string? "api.github.com"]
                     [#:user-agent user-agent string? "racket-github-api-@eu90h"])
         github-api-req/c]{
 Once you've created an identity, apply it to this procedure to receive a
 function for making api requests.
 
The @racket[#:endpoint] keyword sets the root endpoint for making api requests. If you have a GitHub enterprise
account, you may wish to change the endpoint. See @hyperlink["https://developer.github.com/v3/#root-endpoint"
                                                             "this"]
for more information on root-endpoints.

If you change the user-agent string, be aware that GitHub has certain rules explicated @hyperlink["https://developer.github.com/v3/#user-agent-required" "here"]}

@defform[(api-response/c (or/c jsexpr? string?))]
This is a contract for the result of executing a GitHub api request. You are guarenteed either a
JSON expression or a string.

@defform[(github-api-req/c (-> string?
                               [#:method string?
                                #:data string?
                                #:media-type string?]
                               api-response/c))]{
This is a contract for the procedures returned by the function @racket[github-api].
These functions are called with an api request and return a JSON object or a HTTP status code string.
Typically, one would not use this procedure directly but rather pass it along to another function.

The @racket[#:method] keyword specifies what HTTP verb to use (I.e. "GET", "POST", "PATCH", etc.)

The @racket[#:data] keyword specifies any information to send along with the request. This is almost always
 a JSON string.

Finally, @racket[#:media-type] specifies the format in which you wish to receive data. For more information
see @hyperlink["https://developer.github.com/v3/media/" "the GitHub api documentation"].
}


@section{A Note on Identity Security}
According to the GitHub documentation, personal access tokens are equivalent to your password. Never
give it out (and don't accidently commit your identity!)

Read more about your options for authentication @hyperlink["https://developer.github.com/v3/#authentication"
                                                           "here"]


@section{Example}
@racketblock[
 (define personal-token "fs52knf535djbfk2je43b2436")
 (define username "alice")
 (define id (github-identity 'personal-token (list username personal-token)))
 
 (define github-req (github-api id))
 (github-req "/users/plt/repos")
 ]
Here we make a request to get the repositories created by the user plt.

@section{Gists}
@defproc*[([(github-create-gist [api-req github-api-req/c] [files (listof pair?)]) api-response/c]
           [(github-create-gist [api-req github-api-req/c] [files (listof pair?)] [description string?]) api-resonse/c]
           [(github-create-gist [api-req github-api-req/c] [files (listof pair?)] [description string?] [public boolean?]) api-resonse/c])]{
Creates a gist containing files given as a list of pairs @racket[(filename contents)].
 If the gist was created successfully, a @racket[jsexpr?] is returned.

The optional parameter @racket[description] provides a description of the gist. By default it is empty.
The optional parameter @racket[public] determines whether or not the gist is public. By default this is @racket[#f].                                                                                                                                    
           }


@defproc[(github-get-gist [api-req github-api-req/c] [gist-id string?]) api-response/c]
Gets the gist, returning a @racket[jsexpr?] on success.

@defproc*[([(github-edit-gist [api-req github-api-req/c] [gist-id string?] [files (listof pair?)]) api-response/c]
           [(github-edit-gist [api-req github-api-req/c] [gist-id string?] [files (listof pair?)] [description string]) api-response/c])]
Updates a gist. See @racket[github-create-gist] for more explanation of the arguments.

To delete a file from a gist, for example @racket["file1.txt"], add an entry to the @racket[files] list like so:   @racket[(cons "file1.txt" 'delete)].

@defproc[(github-list-gist-commits [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-star-gist [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-unstar-gist [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-gist-starred? [api-req github-api-req/c] [gist-id string?]) boolean?]

@defproc[(github-fork-gist [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-list-gist-forks [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-delete-gist [api-req github-api-req/c] [gist-id string?]) api-response/c]

@defproc[(github-get-gist-revision [api-req github-api-req/c] [gist-id string?] [sha string?]) api-response/c]

@defproc[(github-get-user-gists [api-req github-api-req/c] [user string?]) api-response/c]

@defproc[(github-get-my-gists [api-req github-api-req/c]) api-response/c]

@defproc[(github-get-my-starred-gists [api-req github-api-req/c]) api-response/c]

@defproc[(github-get-all-public-gists [api-req github-api-req/c]) api-response/c]

@section{Examples}

@racketblock[(define new-gist-id
               (let ([response (github-create-gist github-req
                                                   (list (cons "file1.txt" "blah blah blah")
                                                         (cons "file2.txt" "yadda yadda yadda")))])
                 (hash-ref response 'id)))
             
(github-edit-gist github-req new-gist-id
                 (list (cons "file2.txt" 'delete)))

(github-star-gist github-req new-gist-id)
(github-gist-starred? github-req new-gist-id)
(github-unstar-gist github-req new-gist-id)
(github-gist-starred? github-req new-gist-id)

(github-fork-gist github-req new-gist-id)
(github-list-gist-forks github-req new-gist-id)

(github-get-user-gists github-req username)]

@section{Events}

@defproc[(github-list-repo-events [api-req github-api-req/c] [repo-owner string?] [repo string?]) api-response/c]

@defproc[(github-list-repo-issue-events [api-req github-api-req/c] [repo-owner string?] [repo string?]) api-response/c]

@defproc[(github-list-public-org-events [api-req github-api-req/c] [org string?]) api-response/c]

@defproc[(github-list-user-received-events [api-req github-api-req/c] [user string?]) api-response/c]

@defproc[(github-list-user-received-public-events [api-req github-api-req/c] [user string?]) api-response/c]

@defproc[(github-list-user-events [api-req github-api-req/c] [user string?]) api-response/c]

@defproc[(github-list-user-public-events [api-req github-api-req/c] [user string?]) api-response/c]

@section{Feeds}

@defproc[(github-list-feeds [api-req github-api-req/c]) api-response/c]

@defproc[(github-list-notifications [api-req github-api-req/c]) api-response/c]
