//
//  CoreDataTrueFalseGameController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/8/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataTrueFalseGameController: CoreDataViewController {
    
    /******************************************************/
    /******************* Properties **************/
    /******************************************************/
    //MARK: - Properties
    
    let keyTerms = "TFTerms"
    let keySets = "TFSets"
    let keyPerformanceLog = "TFPerformanceLog"
    let keyStudySession = "StudySession"
    
    /******************************************************/
    /******************* Life Cycle **************/
    /******************************************************/
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create FRC for sets
        _ = setupFetchedResultsController(frcKey: keySets, entityName: "QuizletSet",
                                          sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],
                                          predicate: NSPredicate(format: "isActive = %@", argumentArray: [true]))
        
        //create FRC for performance log
        _ = setupFetchedResultsController(frcKey: keyPerformanceLog,
                                          entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
                                          predicate: nil)
        
        //create FRC for study session
        _ = setupFetchedResultsController(frcKey: keyStudySession,
                                          entityName: "StudySession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: true)],
                                          predicate: nil)
        
        self.startStudySession()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.stopStudySession()
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        self.stopStudySession()
    }
    
}

// MARK: - Study sessions

extension CoreDataTrueFalseGameController {
    
    func startStudySession() {
        //only create a new session if self.appsession is nil
        if self.studySession != nil {
            
            print("Cannot create a new StudySession, another StudySession is in progress")
            
        } else {
            
            if frcDict[keyStudySession] == nil {
                print("\(keyStudySession) is nil, creating")
                
                //create FRC for study session
                _ = setupFetchedResultsController(frcKey: keyStudySession,
                                                  entityName: "StudySession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: true)],
                                                  predicate: nil)
                
            } else {
                print("\(keyStudySession) already exitsts, skipping creation")
            }
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let appSession = delegate.appSession
            
            self.studySession = StudySession(start: NSDate(),
                                             stop: nil,
                                             gameId: 0,
                                             appSession: appSession!,
                                             context: self.frcDict[keyStudySession]!.managedObjectContext)
        }
    }
    
    func stopStudySession() {
        //only stop a session if one is in progress
        if let currentStudySession = self.studySession {
            
            //currentStudySession.setValue(NSDate(), forKey: "stop")
            currentStudySession.stop = NSDate()
            //remove the referece to the current session
            //self.studySession = nil
            
        } else {
            print("Cannot stop the StudySession, there is no StudySession to stop")
        }
    }
    
    
}



//performance log functionality
extension CoreDataTrueFalseGameController {
    
    func setupTermFRC(set: QuizletSet) {
        _ = setupFetchedResultsController(frcKey: keyTerms,
                                          entityName: "QuizletTermDefinition",
                                          sortDescriptors: [NSSortDescriptor(key: "rank", ascending: true)],
                                          predicate: NSPredicate(format: "quizletSet = %@", argumentArray: [set]))
    }
    
}

