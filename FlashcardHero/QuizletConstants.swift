//
//  QuizletConstants.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/27/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.

extension QuizletClient {
    
    // MARK: Constants
    struct Constants {
        
        //all info from 
        //https://quizlet.com/api/2.0/docs/api-intro
        
        // MARK: API Keys
        static let ClientID : String = Secrets.QuizletClientID
        static let SecretKey : String = Secrets.QuizletSecretKey
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.quizlet.com"
        static let ApiPath = "/2.0"
        
        static let OAuthScheme = "https"
        static let OAuthHost = "quizlet.com"
        static let OAuthPath = "/authorize"
        
        static let OAuthGetTokenHost = "api.quizlet.com"
        static let OAuthGetTokenPath = "/oauth/token"
    
        // MARK: Methods
        struct Methods {
            
            //MARK: Sets
            static let GETSetById = "/sets/{SET_ID}" //View complete details (including all terms) of a single set.
            static let GETSetTermsById = "/sets/{SET_ID}/terms" //View just the terms in a single set.
            static let GETPasswordProtectedSetById = "/sets/{SET_ID}/{SET_PASSWORD}" // Submit a password for a password-protected set.
            static let GETSets = "/sets" //View complete details of multiple sets at once.
            static let GETClassSetsById = "/classes/{CLASS_ID}/sets" //View complete details of all sets in a class.
            static let GETUsersSetsByUsername = "/users/{USERNAME}/sets" //View complete details about all the user's created sets.
            
            static let POSTAddSet = "/sets" //Add a new set
            static let PUTEditSetById = "/sets/{SET_ID}" // Edit an existing set
            static let DELETESetById = "/sets/{SET_ID}" //Delete an existing set
            static let POSTAddSingleTermToSetById = "/sets/{SET_ID}/terms" //Add a single term to a set
            static let PUTEditSingleTermInSetByIds = "/sets/{SET_ID}/terms/{TERM_ID}" //Edit a single term within a set
            static let DELETESingleTermInSetByIds = "/sets/{SET_ID}/terms/{TERM_ID}" //Delete a single term within a set
            
            //MARK: Search
            static let GETSearchForSet = "/search/sets" //Search for sets by title, description or term. Returns limited information.
            static let GETSearchForClass = "/search/classes" //Search for classes by their title and description.
            static let GETSearchForAll = "/search/universal" //Search for classes, users, and sets all together
            
            //MARK: Users
            static let GETUserInfo = "/users/{USERNAME}" //View basic user information, including their sets, favorites, last 25 sessions, etc.
            static let GETUserSets = "/users/{USERNAME}/sets" //View complete details about all the user's created sets.
            static let GETUserFavoriteSets = "/users/{USERNAME}/favorites" //View complete details about all the user's favorited sets.
            static let GETUserClasses = "/users/{USERNAME}/classes" //View complete details about all the classes that the user is a member of.
            static let GETUserStudied = "/users/{USERNAME}/studied" // View the last 100 recently studied sessions for a user.
            
            //MARK: Favorites
            static let PUTMarkSetFavorite = "/users/{USERNAME}/favorites/{SET_ID}" //Mark a set as a favorite.
            static let DELETEUnmarkSetFavorite = "/users/{USERNAME}/favorites/{SET_ID}" //Unmark a set as a favorite.
            static let GETUsersFavoriteSetsByUsername = "/users/{USERNAME}/favorites" //View complete details about all the user's favorited sets.
            
            //MARK: Classes
            static let GETClassById = "/classes/{CLASS_ID}" //View a single class.
            static let POSTAddClass = "/classes" //Add a new class.
            static let PUTEditClassById = "/classes/{CLASS_ID}" //Edit a class.
            static let DELETEClassById = "/classes/{CLASS_ID}" //Delete a class.
            static let PUTAddSetToClassByIds = "/classes/{CLASS_ID}/sets/{SET_ID}" //Add a set to a class.
            static let DELETESetFromClassByIds = "/classes/{CLASS_ID}/sets/{SET_ID}" //Remove a set from a class.
            static let PUTJoinClassByIds = "/classes/{CLASS_ID}/members/{USERNAME}" // Join (or apply to join) a class.
            static let DELETELeaveClassByIds = "/classes/{CLASS_ID}/members/{USERNAME}" //Leave a class.

        }
        
        struct MethodArgumentKeys {
            static let SetId = "SET_ID"
            static let SetPassword = "SET_PASSWORD"
        }
        
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            
            static let ClientId = "client_id" //required with all public requests
            
            struct Common {
                static let Whitespace = "whitespace" //Add this parameter (whitespace=1) to indent the results for easier human reading of the raw results. This can make testing/debugging easier, and has no effect on the results. Without this parameter, Quizlet will minimize whitespace and network traffic.
                static let Callback = "callback" //A javascript function name for use inside a web application, using the JSON-P method. callback=foo will wrap the response in the foo function: foo({...data...})
                
            }
            
            struct Sets {
                static let ModifiedSince = "modified_since"
            }
            
            struct Users {
                static let ModifiedSince = "modified_since"
            }
            
            struct Classes {
                static let ModifiedSince = "modified_since"
            }
            
            struct Images {
                static let ImageData = "imageData[]" //Upload, An array of one or more images.
            }
            
            //OAuth
            struct OAuth {
                static let Scope = "scope" //The scope(s) you need. Separate multiple scopes with spaces.
                static let ClientID = "client_id" //Your Client ID
                static let ResponseType = "response_type" //Always use the string "code"
                static let State = "state" //A random string generated by you. You send us this, and we'll send it back to you, and you verify that we send back the same thing you sent.                 You must send and verify this value in order to prevent CSRF attacks.
                static let RedirectURI = "redirect_uri" //(optional) A URI to which we should redirect the user. See "about redirect URIs" for details.
                
                static let GrantType = "grant_type" // You must set this to the string "authorization_code".
                static let Code = "code" //The authorization code you received after the user successfully authenticated.
            }
            
            //User Feeds
            struct Feeds {
                static let SeenSetIds = "seenSetIds"
                static let MinTimestamp = "minTimestamp"
                static let Query = "query"
                static let Alphabetize = "alphabetize"
            }
            
            //Search
            struct Search {
                struct Sets {
                    static let Query = "q"
                    static let ModifiedSince = "modified_since"
                    static let Creator = "creator"
                    static let ImagesOnly = "images_only"
                    static let Page = "page"
                    static let PerPage = "per_page"
                }
                
                struct Classes {
                    static let Query = "q" //required
                    static let Page = "page"
                    static let PerPage = "per_page"
                }
                
                struct Universal {
                    static let Query = "q" //required
                    static let Page = "page"
                    static let PerPage = "per_page"
                }
            }
        }
        
        struct ParameterValues {
            struct OAuth {
                static let ResponseType = "code"
                static let GrantType = "authorization_code"
                static let RedirectUri = "flashcardheroapp://after_oauth"
            }
        }
        
        struct ResponseKeys {
            struct GetSets {
                struct SingleSet {
                    static let Id = "id"
                    static let Url = "url"
                    static let Title = "title"
                    static let CreatedBy = "created_by"
                    static let TermCount = "term_count"
                    static let CreatedDate = "created_date"
                    static let ModifiedDate = "modified_date"
                    static let HasImages = "has_images"
                    static let Subjects = "subjects"
                    static let Terms = "terms"
                    
                    struct Term {
                        static let Id = "id" //The term unique identifier.
                        static let Term = "term" //The actual term (front side of the card).
                        static let Definition = "definition" //The definition of the term.
                        static let ImageObject = "image" //An object representing the image for the term. If there is no image associated with this term object, this will be null.
                        
                        struct Image {
                            static let Url = "url" //The URL linking to the associated image.
                            static let Width = "width" //The width of the image, in pixels.
                            static let Height = "width" //The height of the image, in pixels.
                        }
                    }
                    
                }
            }
            
            struct Search {
                struct ForSets {
                    static let TotalResults = "total_results"
                    static let TotalPages = "total_pages"
                    static let ImageSetCount = "image_set_count"
                    static let Page = "page"
                    static let Sets = "sets"
                    
                    struct Set {
                        static let Id = "id"
                        static let Url = "url"
                        static let Title = "title"
                        static let CreatedBy = "created_by"
                        static let TermCount = "term_count"
                        static let CreatedDate = "created_date"
                        static let ModifiedDate = "modified_date"
                        static let HasImages = "has_images"
                        static let Subjects = "subjects"
                    }
                }
            }
        }
        
    }
}
