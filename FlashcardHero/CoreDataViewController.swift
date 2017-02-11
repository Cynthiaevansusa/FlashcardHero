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
    
    var frcDict : [String:NSFetchedResultsController<NSFetchRequestResult>] = [:]
    
//    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
//        didSet {
//            fetchedResultsController?.delegate = self
//            executeSearch()
//        }
//    }
    

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
    
    func executeSearch(frcKey: String) {
        if let fc = frcDict[frcKey] {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(frcDict[frcKey])")
            }
        }
    }
    
    func setupFetchedResultsController(frcKey: String, entityName: String, sortDescriptors: [NSSortDescriptor]? = nil,  predicate: NSPredicate? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let sortDescriptors = sortDescriptors {
            fr.sortDescriptors = sortDescriptors
        }
        
        if let predicate = predicate {
          
            fr.predicate = predicate
        }
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fc.delegate = self
        frcDict[frcKey] = fc
        executeSearch(frcKey: frcKey)
        
        return fc
    }
    
    
    
}

// MARK: - CoreDataCollectionViewController (Fetches)

//extension CoreDataViewController {
//    
//    func executeSearch() {
//        if let fc = fetchedResultsController {
//            do {
//                try fc.performFetch()
//            } catch let e as NSError {
//                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
//            }
//        }
//    }
//
//    
//}


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
            
            
        } else if anObject is AppSession {
            
            switch(type) {
            case .insert:
                
                
                print("case insert AppSession")
            case .delete:
                
                print("case delete AppSession")
            case .update:
                
                print("case update AppSession")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move AppSession")
            }
            
            //save
            stack.save()
            
            
        } else if anObject is QuizletTermDefinition {
            
            switch(type) {
            case .insert:
             
                print("case insert QuizletTermDefinition")
            case .delete:
                
                print("case delete QuizletTermDefinition")
            case .update:
                
                print("case update QuizletTermDefinition")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move QuizletTermDefinition")
            }
            
            //save
            stack.save()
            
            
        } else if anObject is AchievementStepLog {
            
            switch(type) {
            case .insert:
                
                print("case insert AchievementStepLog")
            case .delete:
                
                print("case delete AchievementStepLog")
            case .update:
                
                print("case update AchievementStepLog")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move AchievementStepLog")
            }
            
            //save
            stack.save()
            
            
        } else
        {
            
            var doWhat = ""
            switch(type) {
            case .insert:
                
                
                doWhat = "case insert"
            case .delete:
                
                doWhat = "case delete"
            case .update:
                
                doWhat = "case update"
            case .move:
                //TODO: move a cell... this may not be needed
                doWhat = "case move"
            }
            
            fatalError("Unexpected coreData object attempted to change: \(anObject).  Attempted to \(doWhat)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        //self.tableView.endUpdates()
    }
}
