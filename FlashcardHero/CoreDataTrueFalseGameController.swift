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
    
//    var termFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
//        didSet {
//            // Whenever the frc changes, we execute the search and
//            // reload the table
//            fetchedResultsController?.delegate = self
//            executeTermSearch()
//            //TODO: Reload data
//            //coreMapView.reloadData()
//        }
//    }
    
   
    
    /******************************************************/
    /******************* Life Cycle **************/
    /******************************************************/
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create FRC for sets
        _ = setupFetchedResultsController(frcKey: "TFSets", entityName: "QuizletSet", sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],  predicate: NSPredicate(format: "isActive = %@", argumentArray: [true]))
        
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

// MARK: - CoreDataCollectionViewController (Fetches)

extension CoreDataTrueFalseGameController {
    
//    func executeTermSearch() {
//        if let fc = termFetchedResultsController {
//            do {
//                try fc.performFetch()
//            } catch let e as NSError {
//                print("Error while trying to perform a search: \n\(e)\n\(termFetchedResultsController)")
//            }
//        }
//    }
    
    
}



//performance log functionality
extension CoreDataTrueFalseGameController {
    
    func setupTermFRC(set: QuizletSet) {
        _ = setupFetchedResultsController(frcKey: keyTerms,
                                          entityName: "QuizletTermDefinition",
                                          sortDescriptors: [NSSortDescriptor(key: "rank", ascending: true)],
                                          predicate: NSPredicate(format: "quizletSet = %@", argumentArray: [set]))
    }
    
    func setupPerformanceLogFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "TDPerformanceLog")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        //only return where isActive is set to true
        //let pred = NSPredicate(format: "isActive = %@", argumentArray: [true])
        
        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.performanceLogFetchedResultsController = fc
        
    }
    
}

// MARK: - CoreDataCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataTrueFalseGameController {
    
    override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //about to make updates.  wrapping actions with updates will allow for animation and auto reloading
        //self.tableView.beginUpdates()
    }
    
//    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        if anObject is QuizletSet {
//            
//            switch(type) {
//            case .insert:
//                //from apple documentation
//                //self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
//                
//                //TODO: initiate download of terms?
//                
//                print("case insert")
//            case .delete:
//                //from apple documentation
//                //self.tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
//                
//                print("case delete")
//            case .update:
//                //from apple documentation
//                
//                //nothing is needed here because when data is updated the tableView displays datas current state
//                print("case update")
//            case .move:
//                //TODO: move a cell... this may not be needed
//                print("case move")
//            }
//            
//            //save
//            stack.save()
//            
//            //TODO: Persist the text box
//            
//        } else
//        {
//            fatalError("Couldn't get a QuizletSet from anObject in didChange")
//        }
//    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        //self.tableView.endUpdates()
    }
}
