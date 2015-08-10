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
 
The optional @racket[#:endpoint] keyword sets the root endpoint for making api requests. If you have a GitHub enterprise
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

Finally, @racket[#:media-type] specifies the format in which you wish to receive data.
 Practically every @racket[github-*] procedure has an optional keyword @racket[#:media-type]
 that allows you to specify a media-type for a request.
 
 For more information on media types
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
@section{Working with JSON Data}
When making requests to the GitHub API, it is common to receive data encoded in the
JSON format. This quick section introduces Racket's JSON handling facilities.

Racket provides a library for working with JSON data, aptly called @racket[json].

This is used by the Racket github-api library to encode data before returning it.

Essentially, JSON expressions are represented as hashes. The JSON object
@racketblock[
             { "name": "billy bob" }
             ]
becomes the hash
@racketblock[
            (define jsexpr (make-hash (list (cons 'name "billy bob"))))
             ]
To get the value associated with the key 'name, use @racket[hash-ref] like so:
@racketblock[
             (hash-ref jsexpr 'name)
             ]
which should return @racket["billy bob"]

To learn more about working with hashes see the @hyperlink["http://docs.racket-lang.org/guide/hash-tables.html"
                                                           "Racket guide"]
and the @hyperlink["http://docs.racket-lang.org/reference/hashtables.html"
                   "Racket reference"] on hash-tables.

@section{Gist API}
The Gist API will return up to 1 megabyte of content from a requested gist.

To see if a file was truncated,
check whether or not the key @racket[truncated] is @racket["true"].

To get the full contents of the file,
make a request to the url referenced by the key @racket[raw_url].

For more information on truncation see the @hyperlink["https://developer.github.com/v3/gists/#truncation"
                                                                                                          "GitHub documentation"]

For additional information on the Gist API, check @hyperlink["https://developer.github.com/v3/gists/#gists"
                                                             "here"]
@defproc[(github-create-gist [api-req github-api-req/c]
                           [files (listof pair?)]
                           [#:description description string? ""]
                           [#:public public boolean? #f]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-resonse/c]{
Creates a gist containing files given as a list of pairs @racket[(filename contents)].
 If the gist was created successfully, a @racket[jsexpr?] is returned.

The optional keyword @racket[description] provides a description of the gist. By default it is empty.

The optional keyword @racket[public] determines whether or not the gist is public. By default this is @racket[#f].
}
@defproc[(github-edit-gist [api-req github-api-req/c]
                           [gist-id string?]
                           [files (listof pair?)]
                           [#:description description string? ""]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-resonse/c]{
Updates a gist. See @racket[github-create-gist] for more explanation of the arguments.

To delete a file from a gist, for example @racket["file1.txt"], add an entry to the @racket[files] list like so:   @racket[(cons "file1.txt" 'delete)].
}
@defproc[(github-get-gist [api-req github-api-req/c]
                          [gist-id string?]
                          [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]
Gets the gist, returning a @racket[jsexpr?] on success.

@defproc[(github-list-gist-commits [api-req github-api-req/c]
                                   [gist-id string?]
                                   [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-star-gist [api-req github-api-req/c]
                           [gist-id string?]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-unstar-gist [api-req github-api-req/c]
                             [gist-id string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-gist-starred? [api-req github-api-req/c]
                               [gist-id string?]
                               [#:media-type media-type string? "application/vnd.github.v3+json"])
         boolean?]

@defproc[(github-fork-gist [api-req github-api-req/c]
                           [gist-id string?]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-gist-forks [api-req github-api-req/c]
                                 [gist-id string?]
                                 [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-delete-gist [api-req github-api-req/c]
                             [gist-id string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-gist-revision [api-req github-api-req/c]
                                   [gist-id string?]
                                   [sha string?]
                                   [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-user-gists [api-req github-api-req/c]
                                [user string?]
                                [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-my-gists [api-req github-api-req/c]
                              [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-my-starred-gists [api-req github-api-req/c]
                                      [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-all-public-gists [api-req github-api-req/c]
                                      [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Gist Examples}

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
For more information on the Events API, see @hyperlink["https://developer.github.com/v3/activity/events/"
                                                       "the GitHub documentation"]

@defproc[(github-list-repo-events [api-req github-api-req/c]
                                  [repo-owner string?]
                                  [repo string?]
                                  [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-repo-issue-events [api-req github-api-req/c]
                                        [repo-owner string?]
                                        [repo string?]
                                        [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-public-org-events [api-req github-api-req/c]
                                        [org string?]
                                        [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-user-received-events [api-req github-api-req/c]
                                           [user string?]
                                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-user-received-public-events [api-req github-api-req/c]
                                                  [user string?]
                                                  [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-user-events [api-req github-api-req/c]
                                  [user string?]
                                  [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-user-public-events [api-req github-api-req/c]
                                         [user string?]
                                         [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Feeds}
For more information about feeds, go @hyperlink["https://developer.github.com/v3/activity/feeds/"
                                                "here"]

@defproc[(github-list-feeds [api-req github-api-req/c]
                            [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-notifications [api-req github-api-req/c]
                                    [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Issues}
For more information about the Issues API, click @hyperlink["https://developer.github.com/v3/issues/"
                                                            "here"]

Furthermore, the Issues API uses custom media types. See @hyperlink["https://developer.github.com/v3/issues/#custom-media-types"
                                                                    "this section"]


@defproc[(github-list-issues [api-req github-api-req/c]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-my-issues [api-req github-api-req/c]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-org-issues [api-req github-api-req/c]
                                 [organization string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-repo-issues [api-req github-api-req/c]
                                  [repo-owner string?]
                                  [repo-name string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-create-issue [api-req github-api-req/c]
                              [repo-owner string?]
                              [repo-name string?]
                              [title string?]
                              [#:body body string? ""]
                              [#:assignee assignee string? ""]
                              [#:milestone milestone string? ""]
                              [#:labels label (listof string?) null]
                              [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-edit-issue [api-req github-api-req/c]
                              [repo-owner string?]
                              [repo-name string?]
                              [#:title title string? ""]
                              [#:body body string? ""]
                              [#:assignee assignee string? ""]
                              [#:milestone milestone string? ""]
                              [#:labels label (listof string?) null]
                              [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-repo-issue [api-req github-api-req/c]
                                [repo-owner string?]
                                [repo-name string?]
                                [issue-number string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-issue-comments [api-req github-api-req/c]
                                     [repo-owner string?]
                                     [repo-name string?]
                                     [issue-number string?]
                                     [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-repo-comments [api-req github-api-req/c]
                                    [repo-owner string?]
                                    [repo-name string?]
                                    [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-single-comment [api-req github-api-req/c]
                                    [repo-owner string?]
                                    [repo-name string?]
                                    [comment-id string?]
                                    [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-create-comment [api-req github-api-req/c]
                                [repo-owner string?]
                                [repo-name string?]
                                [issue-number string?]
                                [comment-body string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-edit-comment [api-req github-api-req/c]
                              [repo-owner string?]
                              [repo-name string?]
                              [comment-id string?]
                              [comment-body string?]
                              [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-delete-comment [api-req github-api-req/c]
                                [repo-owner string?]
                                [repo-name string?]
                                [comment-id string?]
                                [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Issue Examples}
@racketblock[
 (github-create-issue github-req
                      "eu90h"
                      "racket-github-api"
                      "testing-issues-api"
                      #:body "this is a test of the issues api"
                      #:assignee "eu90h"
                      #:labels (list "woo!" "test"))
              ]

@section{Repositories}

@defproc[(github-list-repo-assignees [api-req github-api-req/c]
                                     [repo-owner string?]
                                     [repo-name string?]
                                     [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-check-assignee [api-req github-api-req/c]
                                [repo-owner string?]
                                [repo-name string?]
                                [user string?]
                                [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Git Data}
@defproc[(github-get-blob [api-req github-api-req/c]
                          [repo-owner string?]
                          [repo-name string?]
                          [sha string?]
                          [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-create-blob [api-req github-api-req/c]
                             [repo-owner string?]
                             [repo-name string?]
                             [content string?]
                             [encoding string? "utf-8"]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-commit [api-req github-api-req/c]
                             [repo-owner string?]
                             [repo-name string?]
                             [sha string?]
                             [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-create-commit [api-req github-api-req/c]
                               [repo-owner string?]
                               [repo-name string?]
                               [message string?]
                               [tree string?]
                               [parents (listof string?)]
                               [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Organizations}

@defproc[(github-list-orgs [api-req github-api-req/c]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-all-orgs [api-req github-api-req/c]
                               [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-user-orgs [api-req github-api-req/c]
                                [user string?]
                                [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-org [api-req github-api-req/c]
                         [org string?]
                         [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-org-members [api-req github-api-req/c]
                         [org string?]
                         [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-list-pull-requests [api-req github-api-req/c]
                                    [repo-owner string?]
                                    [repo string?]
                                    [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@section{Users}
@defproc[(github-get-user [api-req github-api-req/c]
                          [user string?]
                          [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-authenticated-user [api-req github-api-req/c]
                                        [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-all-users [api-req github-api-req/c]
                               [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]
@section{Webhooks & Service Hooks}
Webhooks are a sort-of user defined callback in the form of a listening webserver that github sends a
message to whenever a certain type of event occurs.

A service hook is a webhook whose type is anything except @racket["web"]

To read more, see the @hyperlink["https://developer.github.com/webhooks/"
                                 "GitHub documentation"]


@defproc[(github-build-webhook-config [api-req github-api-req/c]
                                      [url string?]
                                      [#:content-type content-type string? "form"]
                                      [#:secret secret string? ""]
                                      [#:insecure-ssl insecure-ssl string? "0"])
         api-response/c]

@defproc[(github-hook-repo [api-req github-api-req/c]
                           [repo-owner string?]
                           [repo string?]
                           [type string?]
                           [config jsexpr?]
                           [#:events events (listof string?) '("push")]
                           [#:active active boolean? #t])
         api-response/c]
The @racket[type] parameter must be the string @racket["web"] or a service name defined in @hyperlink["https://api.github.com/hooks"
                                                                                                      "this"] rather inconvenient JSON file.

Passing any other string results in an error response from the GitHub API.

Note: The @racket[type] parameter is referred to in the GitHub documentation (misleadingly, I think) as the
name of the webhook.
@defproc[(github-get-hooks [api-req github-api-req/c]
                           [repo-owner string?]
                           [repo string?]
                           [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-get-hook [api-req github-api-req/c]
                          [repo-owner string?]
                          [repo string?]
                          [hook-id (or/c string? number?)]
                          [#:media-type media-type string? "application/vnd.github.v3+json"])
         api-response/c]

@defproc[(github-test-push-hook [api-req github-api-req/c]
                                [repo-owner string?]
                                [repo string?]
                                [hook-id (or/c string? number?)])
         api-response/c]

@defproc[(github-ping-hook [api-req github-api-req/c]
                           [repo-owner string?]
                           [repo string?]
                           [hook-id (or/c string? number?)])
         api-response/c]

@defproc[(github-delete-hook [api-req github-api-req/c]
                             [repo-owner string?]
                             [repo string?]
                             [hook-id (or/c string? number?)])
         api-response/c]
@section{Webhooks Example}
@racketblock[
 (define config (github-build-webhook-config "http://example.com"
                                             #:insecure-ssl "0"
                                             #:content-type "json"))
 (define hook-data (github-hook-repo github-req username my-repo "web" config))
 (define hook-id (hash-ref hook-data 'id))
 (github-get-hooks github-req username my-repo)
 (define del-hook (thunk (github-delete-hook github-req username my-repo hook-id)))
 ...
 (define delete-response (del-hook))
 (if (and (string? delete-response) (= 204 (get-status-code delete-response)))
     (displayln "successfully removed webhook")
     (displayln "trouble removing webhook"))]