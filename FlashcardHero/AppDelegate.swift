//
//  AppDelegate.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSFetchedResultsControllerDelegate {

    var window: UIWindow?
    let stack = CoreDataStack(modelName: "FlashcardHeroModel")!
    
    
    /******************************************************/
    /*******************///MARK: AppSessions CoreData
    /******************************************************/

    var appSession: AppSession?
    var appSessionFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            appSessionFetchedResultsController?.delegate = self
        }
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
        createNewAppSession()
        stack.save()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //endCurrentAppSession()
        stack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //endCurrentAppSession()
        stack.save()
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

