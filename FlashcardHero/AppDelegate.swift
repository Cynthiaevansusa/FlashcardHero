//
//  AppDelegate.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
import CoreData
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSFetchedResultsControllerDelegate {

    var window: UIWindow?
    let stack = CoreDataStack(modelName: "FlashcardHeroModel")!
    var oAuthCode : String? = nil
    var oAuthState : String? = nil
    let oAuthTokenKeychainKey = "FlashcardHeroOAuthToken"
    let quizletUserIdKeychainKey = "FlashcardHeroQuizletUserId"
    
    fileprivate var quizletUserId: String? = nil
    
    
    /******************************************************/
    /*******************///MARK: AppSessions CoreData
    /******************************************************/

    var appSession: AppSession?
    var appSessionFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            appSessionFetchedResultsController?.delegate = self
        }
    }
    
    // some code adapted from http://jayeshkawli.ghost.io/ios-custom-url-schemes/
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("Received a URL: \(url)")
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        let parameters = (urlComponents?.queryItems)! as [NSURLQueryItem]
        
        var wasSuccessful = true

        if (url.scheme == "flashcardheroapp" && url.host == "after_oauth") {
            
            var tempCode : String?
            var tempState : String?
            
            for parameter in parameters {
                switch parameter.name {
                case "code":
                    print("code is \(parameter.value)")
                    tempCode = parameter.value
                case "state":
                    //check state against the code sent in request
                    print("state is \(parameter.value)")
                    tempState = parameter.value
                case "expires_in":
                    print("expires_in is \(parameter.value)")
                case "error":
                    print("error is \(parameter.value)")
                    wasSuccessful = false
                case "error_description":
                    print("error_description is \(parameter.value)")
                    wasSuccessful = false
                default:
                    print("Recieved an unexpected item: \(parameter.name)")
                    //TODO: handle unexpected parameter
                }
            }
            
            guard wasSuccessful, let code = tempCode, let state = tempState else { return false }
            
            //got all the parameters expected for log in
            print("Successfully got a code")
            
            //check that state is the same
            guard state == oAuthState else {
                print("States don't match! \(state) vs \(oAuthState)")
                return false
            }
            
            self.oAuthCode = code
            
            //proceed to step 2 of Quizlet OAuth login
            let _ = QuizletClient.sharedInstance.getQuizletOAuthToken(with: code) { (results, error) in
                print("getQuizletOAuthToken completion")
                guard let results = results else {
                    print("Got an Error: \(error)")
                    return
                }
                    
                guard let token = results[QuizletClient.Constants.ResponseKeys.OAuth.AccessToken] as? String,
                    let userId = results[QuizletClient.Constants.ResponseKeys.OAuth.UserId] as? String else {
                        print("Couldn't obtain the token from \(results)")
                        return
                }
                print("Got a token and userId successfully: \(token), \(userId)")
                
                guard self.setTokenToKeychain(token: token), self.setQuizletUserId(userId: userId) else { return }
                
                //got a token, user is logged in, do the login steps
                guard token == self.getTokenFromKeychain() && userId == self.getQuizletUserId() else {
                    print("Token we just tried to set doesn't match the token we got! \(token) doesn't match \(self.getTokenFromKeychain()) or \(userId) doesn't match \(self.getQuizletUserId())")
                    return }
                
                //userId and token have been set and can be retrieved.
                print("Userid and Token have been successfully set!")
                
                //refresh the Gems Manager, that is where users login
                // switch root view controllers
//                let vcArray = self.window?.rootViewController?.childViewControllers
//                var gemVC: GemManagerViewController
//                for vc in vcArray! {
//                    if let vc = vc as? GemManagerViewController {
//                        gemVC = vc
//                        print("VC is \(gemVC)")
//                        
//                        gemVC.viewWillAppear(true)
//                        break
//                    }
//                }
            }
            
        }
        
        return true
    }
    
    func isUserLoggedIn() -> Bool {
        //user is considered to be logged in if getQuizletUserId returns a userId, and if an oAuth token is returned
        
        if getQuizletUserId() != nil && getTokenFromKeychain() != nil {
            print("User is logged in.")
            return true
        } else {
            print("User is logged NOT in.")
            return false
        }
    }
    
    func logUserOut() -> Bool {
        //delete the userId and the token and make sure they are gone
        let keychain = KeychainSwift()
        
        if keychain.delete(self.oAuthTokenKeychainKey) && keychain.delete(self.quizletUserIdKeychainKey) {
            self.quizletUserId = nil
            if !isUserLoggedIn() {
                print("User successfully logged out.")
                return true
            } else {
                //TODO: handle failing to log out
                print("Failed to log user out... isUserLoggedIn is returning TRUE")
                return false
            }
            
        } else {
            //TODO: properly handle not logging out
            print("Failed to log user out")
            return false
        }
    }
    
    func setQuizletUserId(userId: String) -> Bool {
        let keychain = KeychainSwift()
        if keychain.set(userId, forKey: self.quizletUserIdKeychainKey) {
            //put in memory
            self.quizletUserId = userId
            
            if keychain.get(self.quizletUserIdKeychainKey) == userId && userId == self.quizletUserId {
                print("Keychain userId set successful")
                return true
            } else {
                print("Couldn't get the userId we just set! \(userId) \(self.quizletUserId)")
                return false
            }
        } else {
            print("Keychain userId set failed!")
            if keychain.lastResultCode != noErr { /* //TODO: report error to set keychain */ }
            
            self.quizletUserId = nil
            return false
        }
    }
    
   
    
    //getting the userId
    func getQuizletUserId() -> String? {
        let keychain = KeychainSwift()
        //check that memory and keychain match
        if let userId = self.quizletUserId, let kUserId = keychain.get(self.quizletUserIdKeychainKey), userId == kUserId {
            //they are both set, so return
            print("Keychain and local memory match.  UserId returned: \(userId)")
            return userId
        } else {
            //one or more of them is not set
            switch (self.quizletUserId == nil, keychain.get(self.quizletUserIdKeychainKey) == nil) {
            case (true, true):
                //neither is set, user is not logged in and must do so
                print("No userId found in memory or in keychain. \(self.quizletUserId), \(keychain.get(self.quizletUserIdKeychainKey))")
                return nil
            case (false, true):
                //in memory, but not in keychain
                print("userId in memory but not in Keychain. Returning nil. \(self.quizletUserId), \(keychain.get(self.quizletUserIdKeychainKey))")
                //for safety, will return nil
                return nil
            case (true, false):
                //not in memory, but in keyChain
                print("no userId in memory.  Setting. \(self.quizletUserId), \(keychain.get(self.quizletUserIdKeychainKey))")
                //put into memory
                self.quizletUserId = keychain.get(self.quizletUserIdKeychainKey)
                return self.quizletUserId
            case (false, false):
                //they did not match
                print("memory and keychain don't match. Overwriting memory. \(self.quizletUserId), \(keychain.get(self.quizletUserIdKeychainKey))")
                //override in memory from keychain
                self.quizletUserId = keychain.get(self.quizletUserIdKeychainKey)
                return self.quizletUserId
            }
        }
    }
    
    //set's the app's quizlet token into the keychain
    func setTokenToKeychain(token: String) -> Bool {
        let keychain = KeychainSwift()
        if keychain.set(token, forKey: self.oAuthTokenKeychainKey) {
            if keychain.get(self.oAuthTokenKeychainKey) == token {
                print("Keychain token set successful")
                return true
            } else {
                print("Couldn't get the key we just set! \(token)")
                return false
            }
            
        } else {
            print("Keychain token set failed!")
            if keychain.lastResultCode != noErr { /* //TODO: report error to set keychain */ }
            return false
        }
    }
    
    //returns an optional string from the keychain for the app's Quizlet token
    func getTokenFromKeychain() -> String? {
        let keychain = KeychainSwift()
        let gotKey = keychain.get(self.oAuthTokenKeychainKey)
        print("Got token from keychain \(gotKey)")
        return gotKey
    }

    
    func createNewAppSession() {
    
        //only create a new session if self.appsession is nil
        if self.appSession != nil {
        
            print("Cannot create a new AppSession, another AppSession is in progress")
        
        } else {
            
            if self.appSessionFetchedResultsController == nil {
                // Create Fetch Request
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSession")
                
                fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
                
                //only get sets that are active
                //        let pred = NSPredicate(format: "quizletSet = %@", argumentArray: [set])
                //
                //        fr.predicate = pred
                
                // Create FetchedResultsController
                let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
                
                self.appSessionFetchedResultsController = fc
            }
            
            self.appSession = AppSession(start: NSDate(),
                                         stop: nil,
                                         context: self.appSessionFetchedResultsController!.managedObjectContext)
        }
    }
    
    func endCurrentAppSession() {
        //only stop a session if one is in progress
        if let currentAppSession = self.appSession {
            
            currentAppSession.stop = NSDate()
            
            //remove the referece to the current session
            self.appSession = nil
            
        } else {
           print("Cannot stop the AppSession, there is no AppSession to stop")
        }
    }
    
    func executeAppSessionSearch() {
        if let fc = appSessionFetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(appSessionFetchedResultsController)")
            }
        }
    }

    
    /******************************************************/
    /*******************///MARK: Standard AppDelegate
    /******************************************************/

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        do {
//            try stack.dropAllData()
//        } catch {
//            print("error while trying to drop all data")
//        }
        createNewAppSession()
        stack.save()
        
        //adapted from http://stackoverflow.com/questions/12878162/how-can-i-show-a-view-on-the-first-launch-only to show orientation
        if !UserDefaults.standard.bool(forKey: "Walkthrough") {
            print("User has not seen the walkthrough yet")
            UserDefaults.standard.set(false, forKey: "Walkthrough")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //endCurrentAppSession()
        //stack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //endCurrentAppSession()
        //stack.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        endCurrentAppSession()
        stack.save()
    }


}

