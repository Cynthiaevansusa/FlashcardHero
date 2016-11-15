//
//  CoreDataViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/7/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataViewController: UIViewController {
    
    /******************************************************/
    /******************* Properties **************/
    /******************************************************/
    //MARK: - Properties
    
    var studySession: StudySession?
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            fetchedResultsController?.delegate = self
            executeSearch()
        }
    }
    
    var performanceLogFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            performanceLogFetchedResultsController?.delegate = self
            executePerformanceLogSearch()
        }
    }
    
    var studySessionFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            studySessionFetchedResultsController?.delegate = self
            executeStudySessionSearch()
        }
    }
    
    
    
    var stack: CoreDataStack!
    
    /******************************************************/
    /******************* Life Cycle **************/
    /******************************************************/
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }
    
}

// MARK: - CoreDataCollectionViewController (Fetches)

extension CoreDataViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
    func executePerformanceLogSearch() {
        if let fc = performanceLogFetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(performanceLogFetchedResultsController)")
            }
        }
    }
    
    func executeStudySessionSearch() {
        if let fc = studySessionFetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(studySessionFetchedResultsController)")
            }
        }
    }
    
    
}

//studySession functionality
extension CoreDataTrueFalseGameController {
    func setupStudySessionFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "StudySession")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
        //only get sets that are active
        //let pred = NSPredicate(format: "quizletSet = %@", argumentArray: [set])
        
        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.studySessionFetchedResultsController = fc
        
    }
    
    func startStudySession() {
        //only create a new session if self.appsession is nil
        if self.studySession != nil {
            
            print("Cannot create a new StudySession, another StudySession is in progress")
            
        } else {
            
            if self.studySessionFetchedResultsController == nil {
                // Create Fetch Request
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "StudySession")
                
                fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
                
                //only get sets that are active
                //        let pred = NSPredicate(format: "quizletSet = %@", argumentArray: [set])
                //
                //        fr.predicate = pred
                
                // Create FetchedResultsController
                let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
                
                self.studySessionFetchedResultsController = fc
            }
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let appSession = delegate.appSession
            
            self.studySession = StudySession(start: NSDate(),
                                             stop: nil,
                                             gameId: 0,
                                             appSession: appSession!,
                                             context: self.studySessionFetchedResultsController!.managedObjectContext)
        }
    }
    
    func stopStudySession() {
        //only stop a session if one is in progress
        if let currentStudySession = self.studySession {
            
            //currentStudySession.setValue(NSDate(), forKey: "stop")
            currentStudySession.stop = NSDate()
            //remove the referece to the current session
            self.studySession = nil
            
        } else {
            print("Cannot stop the StudySession, there is no StudySession to stop")
        }
    }
}

// MARK: - CoreDataCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //about to make updates.  wrapping actions with updates will allow for animation and auto reloading
        //self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if anObject is QuizletSet {
            
            switch(type) {
            case .insert:
                //from apple documentation
                //self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
                
                //TODO: initiate download of terms?
                
                print("case insert")
            case .delete:
                //from apple documentation
                //self.tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                
                print("case delete")
            case .update:
                //from apple documentation
                
                //nothing is needed here because when data is updated the tableView displays datas current state
                print("case update")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move")
            }
            
            //save
            stack.save()
            
        } else if anObject is TDPerformanceLog {
            
            switch(type) {
            case .insert:

                
                print("case insert TDPerformanceLog")
            case .delete:
                
                print("case delete TDPerformanceLog")
            case .update:

                print("case update TDPerformanceLog")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move TDPerformanceLog")
            }
            
            //save
            stack.save()
            
        } else if anObject is StudySession {
            
            switch(type) {
            case .insert:
                
                
                print("case insert StudySession")
            case .delete:
                
                print("case delete StudySession")
            case .update:
                
                print("case update StudySession")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move StudySession")
            }
            
            //save
            stack.save()
            
            
        } else
        {
            fatalError("Couldn't get a QuizletSet from anObject in didChange")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        //self.tableView.endUpdates()
    }
}
