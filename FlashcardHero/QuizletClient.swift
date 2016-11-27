//
//  QuizletClient.swift
//  FlashcardHero
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further development by Jacob Foster Davis on 10/27/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.

import Foundation
import UIKit

// MARK: - ParseClient: NSObject

class QuizletClient : NSObject {
    
    // MARK: Shared Instance
    static let sharedInstance = QuizletClient()
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETImage(filePath: String, completionHandlerForGETImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        //none
        
        var url = URL(string: filePath)
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: url!)
        //        request.addValue(Secrets.FlickrAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        //        request.addValue(Secrets.FlickrRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        print("Starting task for URL: \(request.url!)")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETImage(nil, NSError(domain: "taskForGETImage", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription, code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code other than 2xx! Status code \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 3)
                return
            }
            
            /* 5/6. return data */
            completionHandlerForGETImage(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETMethod(method: String, parameters: [String:Any], shouldUseAuthentication: Bool = false, completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var passTheseParameters = parameters
        //add the ClientId, required with every public request
        passTheseParameters[Constants.ParameterKeys.ClientId] = Constants.ClientID as AnyObject?
        
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: QuizletURLFromParameters(passTheseParameters, withPathExtension: method))
        
        //if using Authentication, add to header
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if shouldUseAuthentication && delegate.isUserLoggedIn() {
            let accessToken = delegate.getTokenFromKeychain()
            if let accessToken = accessToken {
                var AuthString = "Bearer \(accessToken)"
                request.addValue(AuthString, forHTTPHeaderField: "Authorization")
                print("Added authorization header to a request: \(AuthString)")
            } else {
                print("User is logged in but authentication token returned nil")
            }
        } else if shouldUseAuthentication {
            print("Authentication was requested but the user is not logged in")
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription, code: 1)
                return
            }
            
            //TODO: Use the JSON resonse from Quizlet to give more specific reasons for errors.
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode400 = (response as? HTTPURLResponse)?.statusCode , statusCode400 != 400 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 400 (Bad Request) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode401 = (response as? HTTPURLResponse)?.statusCode , statusCode401 != 401 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 401 (Unauthorized) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode404 = (response as? HTTPURLResponse)?.statusCode , statusCode404 != 404 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 404 (Not Found) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode405 = (response as? HTTPURLResponse)?.statusCode , statusCode405 != 405 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 405 (Method Not Allowed) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 5xx response? */
            guard let statusCode500 = (response as? HTTPURLResponse)?.statusCode , statusCode500 != 500 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 500 (Server Error) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode2xx = (response as? HTTPURLResponse)?.statusCode , statusCode2xx >= 200 && statusCode2xx <= 299 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code other than 2xx! Status code \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            

            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 3)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        //let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) //don't need to this for Parse
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "\nDATA CONVERT ERROR: Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 4, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    func QuizletURLFromParameters(_ parameters: [String:Any]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        print("About to return a URL: " + (components.url?.absoluteString)!)
        return components.url!
    }
    
}
