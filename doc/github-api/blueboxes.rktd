4236
((3) 0 () 2 ((q lib "github-api/main.rkt") (q 0 . 5)) () (h ! (equal) ((c def c (c (? . 0) q github-fork-gist)) q (3355 . 7)) ((c def c (c (? . 0) q github-list-repo-comments)) q (12706 . 10)) ((c def c (c (? . 0) q github-identity-data)) c (? . 1)) ((c def c (c (? . 0) q github-create-issue)) q (10007 . 19)) ((c def c (c (? . 0) q github-get-all-users)) q (20679 . 5)) ((c def c (c (? . 0) q github-get-my-starred-gists)) q (5245 . 6)) ((c def c (c (? . 0) q github-list-repo-issues)) q (9602 . 10)) ((c def c (c (? . 0) q github-list-user-received-public-events)) q (7243 . 9)) ((c def c (c (? . 0) q github-unstar-gist)) q (2723 . 7)) ((c def c (c (? . 0) q github-delete-gist)) q (3982 . 7)) ((c def c (c (? . 0) q github-list-user-orgs)) q (18788 . 8)) ((c def c (c (? . 0) q github-list-my-issues)) q (9044 . 6)) ((c def c (c (? . 0) q github-list-notifications)) q (8566 . 6)) ((c def c (c (? . 0) q github-edit-gist)) q (1296 . 11)) ((c def c (c (? . 0) q github-get-blob)) q (16128 . 11)) ((c def c (c (? . 0) q github-list-issue-comments)) q (12201 . 12)) ((c def c (c (? . 0) q github-list-user-received-events)) q (6899 . 8)) ((c def c (c (? . 0) q github-list-org-issues)) q (9280 . 8)) ((c def c (c (? . 0) q github-get-gist)) q (1783 . 7)) ((c form c (c (? . 0) q api-response/c)) q (447 . 2)) ((c def c (c (? . 0) q github-get-single-comment)) q (13119 . 12)) ((c def c (c (? . 0) q github-identity-type)) c (? . 1)) ((c def c (c (? . 0) q github-list-repo-events)) q (5741 . 10)) ((c def c (c (? . 0) q github-list-user-events)) q (7679 . 8)) ((c def c (c (? . 0) q github-list-repo-assignees)) q (15239 . 10)) ((c def c (c (? . 0) q github-list-all-orgs)) q (18550 . 5)) ((c def c (c (? . 0) q github-list-orgs)) q (18320 . 5)) ((c form c (c (? . 0) q github-api-req/c)) q (497 . 6)) ((c def c (c (? . 0) q github-get-my-gists)) q (5009 . 5)) ((c def c (c (? . 0) q github-get-org)) q (19099 . 7)) ((c def c (c (? . 0) q github-create-commit)) q (17650 . 15)) ((c def c (c (? . 0) q github-create-gist)) q (791 . 11)) ((c def c (c (? . 0) q github-identity?)) c (? . 1)) ((c def c (c (? . 0) q github-create-blob)) q (16594 . 13)) ((c def c (c (? . 0) q github-star-gist)) q (2413 . 7)) ((c def c (c (? . 0) q github-list-issues)) q (8810 . 5)) ((c def c (c (? . 0) q github-check-assignee)) q (15656 . 12)) ((c def c (c (? . 0) q github-get-authenticated-user)) q (20427 . 6)) ((c def c (c (? . 0) q github-list-repo-issue-events)) q (6141 . 10)) ((c def c (c (? . 0) q make-github-identity)) c (? . 1)) ((c def c (c (? . 0) q github-get-user-gists)) q (4698 . 8)) ((c def c (c (? . 0) q github-get-gist-revision)) q (4298 . 10)) ((c def c (c (? . 0) q github-gist-starred?)) q (3039 . 7)) ((c def c (c (? . 0) q github-get-user)) q (20123 . 7)) ((c def c (c (? . 0) q github-list-gist-commits)) q (2090 . 8)) ((c def c (c (? . 0) q github-get-hooks)) q (21991 . 9)) ((c def c (c (? . 0) q github-list-feeds)) q (8334 . 5)) ((c def c (c (? . 0) q github-list-pull-requests)) q (19715 . 10)) ((c def c (c (? . 0) q github-ping-hook)) q (23185 . 9)) ((c def c (c (? . 0) q github-edit-comment)) q (14180 . 13)) ((c def c (c (? . 0) q github-get-hook)) q (22381 . 11)) ((c def c (c (? . 0) q struct:github-identity)) c (? . 1)) ((c def c (c (? . 0) q github-api)) q (141 . 7)) ((c def c (c (? . 0) q github-delete-hook)) q (23487 . 9)) ((c def c (c (? . 0) q github-create-comment)) q (13617 . 14)) ((c def c (c (? . 0) q github-get-commit)) q (17174 . 11)) ((c def c (c (? . 0) q github-list-gist-forks)) q (3665 . 8)) ((c def c (c (? . 0) q github-get-all-public-gists)) q (5493 . 6)) ((c def c (c (? . 0) q github-edit-issue)) q (10869 . 19)) ((c def c (c (? . 0) q github-identity)) c (? . 1)) ((c def c (c (? . 0) q github-list-user-public-events)) q (7996 . 8)) ((c def c (c (? . 0) q github-hook-repo)) q (21430 . 15)) ((c def c (c (? . 0) q github-get-repo-issue)) q (11721 . 12)) ((c def c (c (? . 0) q github-list-org-members)) q (19399 . 8)) ((c def c (c (? . 0) q github-list-public-org-events)) q (6565 . 8)) ((c def c (c (? . 0) q github-build-webhook-config)) q (20917 . 12)) ((c def c (c (? . 0) q github-test-push-hook)) q (22863 . 9)) ((c def c (c (? . 0) q github-delete-comment)) q (14761 . 12))))
struct
(struct github-identity (type data)
    #:extra-constructor-name make-github-identity)
  type : symbol?
  data : list?
procedure
(github-api  id                            
            [#:endpoint endpoint           
             #:user-agent user-agent]) -> github-api-req/c
  id : github-identity?
  endpoint : string? = "api.github.com"
  user-agent : string? = "racket-github-api-@eu90h"
syntax
(api-response/c (or/c jsexpr? string?))
syntax
(github-api-req/c (-> string?
                      [#:method string?
                       #:data string?
                       #:media-type string?]
                      api-response/c))
procedure
(github-create-gist  api-req                       
                     files                         
                    [#:description description     
                     #:public public               
                     #:media-type media-type]) -> api-resonse/c
  api-req : github-api-req/c
  files : (listof pair?)
  description : string? = ""
  public : boolean? = #f
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-edit-gist  api-req                       
                   gist-id                       
                   files                         
                  [#:description description     
                   #:media-type media-type]) -> api-resonse/c
  api-req : github-api-req/c
  gist-id : string?
  files : (listof pair?)
  description : string? = ""
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-gist  api-req                       
                  gist-id                       
                 [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-gist-commits  api-req                   
                           gist-id                   
                          [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-star-gist  api-req                       
                   gist-id                       
                  [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-unstar-gist  api-req                       
                     gist-id                       
                    [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-gist-starred?  api-req                       
                       gist-id                       
                      [#:media-type media-type]) -> boolean?
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-fork-gist  api-req                       
                   gist-id                       
                  [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-gist-forks  api-req                   
                         gist-id                   
                        [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-delete-gist  api-req                       
                     gist-id                       
                    [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-gist-revision  api-req                   
                           gist-id                   
                           sha                       
                          [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  gist-id : string?
  sha : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-user-gists  api-req                   
                        user                      
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-my-gists  api-req                       
                     [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-my-starred-gists  api-req                   
                             [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-all-public-gists  api-req                   
                             [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-repo-events  api-req                   
                          repo-owner                
                          repo                      
                         [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-repo-issue-events  api-req                   
                                repo-owner                
                                repo                      
                               [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-public-org-events  api-req                   
                                org                       
                               [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  org : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-user-received-events  api-req                   
                                   user                      
                                  [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-user-received-public-events                            
                                          api-req                   
                                          user                      
                                         [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-user-events  api-req                   
                          user                      
                         [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-user-public-events  api-req                   
                                 user                      
                                [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-feeds  api-req                       
                   [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-notifications  api-req                   
                           [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-issues  api-req                       
                    [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-my-issues  api-req                   
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-org-issues  api-req                   
                         organization              
                        [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  organization : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-repo-issues  api-req                   
                          repo-owner                
                          repo-name                 
                         [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-create-issue  api-req                       
                      repo-owner                    
                      repo-name                     
                      title                         
                     [#:body body                   
                      #:assignee assignee           
                      #:milestone milestone         
                      #:labels label                
                      #:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  title : string?
  body : string? = ""
  assignee : string? = ""
  milestone : string? = ""
  label : (listof string?) = null
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-edit-issue  api-req                       
                    repo-owner                    
                    repo-name                     
                   [#:title title                 
                    #:body body                   
                    #:assignee assignee           
                    #:milestone milestone         
                    #:labels label                
                    #:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  title : string? = ""
  body : string? = ""
  assignee : string? = ""
  milestone : string? = ""
  label : (listof string?) = null
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-repo-issue  api-req                   
                        repo-owner                
                        repo-name                 
                        issue-number              
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  issue-number : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-issue-comments  api-req                   
                             repo-owner                
                             repo-name                 
                             issue-number              
                            [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  issue-number : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-repo-comments  api-req                   
                            repo-owner                
                            repo-name                 
                           [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-single-comment  api-req                   
                            repo-owner                
                            repo-name                 
                            comment-id                
                           [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  comment-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-create-comment  api-req                   
                        repo-owner                
                        repo-name                 
                        issue-number              
                        comment-body              
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  issue-number : string?
  comment-body : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-edit-comment  api-req                       
                      repo-owner                    
                      repo-name                     
                      comment-id                    
                      comment-body                  
                     [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  comment-id : string?
  comment-body : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-delete-comment  api-req                   
                        repo-owner                
                        repo-name                 
                        comment-id                
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  comment-id : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-repo-assignees  api-req                   
                             repo-owner                
                             repo-name                 
                            [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-check-assignee  api-req                   
                        repo-owner                
                        repo-name                 
                        user                      
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-blob  api-req                       
                  repo-owner                    
                  repo-name                     
                  sha                           
                 [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  sha : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-create-blob  api-req                       
                     repo-owner                    
                     repo-name                     
                     content                       
                    [encoding                      
                     #:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  content : string?
  encoding : string? = "utf-8"
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-commit  api-req                       
                    repo-owner                    
                    repo-name                     
                    sha                           
                   [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  sha : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-create-commit  api-req                       
                       repo-owner                    
                       repo-name                     
                       message                       
                       tree                          
                       parents                       
                      [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo-name : string?
  message : string?
  tree : string?
  parents : (listof string?)
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-orgs  api-req                       
                  [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-all-orgs  api-req                       
                      [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-user-orgs  api-req                   
                        user                      
                       [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-org  api-req                       
                 org                           
                [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  org : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-org-members  api-req                   
                          org                       
                         [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  org : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-list-pull-requests  api-req                   
                            repo-owner                
                            repo                      
                           [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-user  api-req                       
                  user                          
                 [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  user : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-authenticated-user  api-req                   
                               [#:media-type media-type]) 
 -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-all-users  api-req                       
                      [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-build-webhook-config  api-req                       
                              url                           
                             [#:content-type content-type   
                              #:secret secret               
                              #:insecure-ssl insecure-ssl]) 
 -> api-response/c
  api-req : github-api-req/c
  url : string?
  content-type : string? = "form"
  secret : string? = ""
  insecure-ssl : string? = "0"
procedure
(github-hook-repo  api-req               
                   repo-owner            
                   repo                  
                   type                  
                   config                
                  [#:events events       
                   #:active active]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  type : string?
  config : jsexpr?
  events : (listof string?) = '("push")
  active : boolean? = #t
procedure
(github-get-hooks  api-req                       
                   repo-owner                    
                   repo                          
                  [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-get-hook  api-req                       
                  repo-owner                    
                  repo                          
                  hook-id                       
                 [#:media-type media-type]) -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  hook-id : (or/c string? number?)
  media-type : string? = "application/vnd.github.v3+json"
procedure
(github-test-push-hook api-req        
                       repo-owner     
                       repo           
                       hook-id)   -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  hook-id : (or/c string? number?)
procedure
(github-ping-hook api-req        
                  repo-owner     
                  repo           
                  hook-id)   -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  hook-id : (or/c string? number?)
procedure
(github-delete-hook api-req        
                    repo-owner     
                    repo           
                    hook-id)   -> api-response/c
  api-req : github-api-req/c
  repo-owner : string?
  repo : string?
  hook-id : (or/c string? number?)
