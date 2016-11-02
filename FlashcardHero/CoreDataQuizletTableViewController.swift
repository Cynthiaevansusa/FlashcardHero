//
//  CoreDataQuizletTableViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/1/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataQuizletTableViewController: UIViewController, UITableViewDelegate {
    
    /******************************************************/
    /******************* Properties **************/
    /******************************************************/
    //MARK: - Properties
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            //TODO: Reload data
            //coreMapView.reloadData()
        }
    }
    
//    var fetchedTextResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
//        didSet {
//            // Whenever the frc changes, we execute the search and
//            // reload the table
//            fetchedTextResultsController?.delegate = self
//            executeTextSearch()
//            //TODO: Reload data
//            //coreMapView.reloadData()
//        }
//    }
    
    
    
    var tableView: UITableView!
    var setsToDisplay = [QuizletSet]()
    
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
    
    /******************************************************/
    /******************* UITableViewDelegate Delegate and Data Source **************/
    /******************************************************/
    //MARK: - UITableViewDelegate Delegate and Data Source
    
    
    //When a user selects an item from the collection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("This stub should be implimented by a child class")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("This stub should be implimented by a child class")
    }
    
}

// MARK: - CoreDataCollectionViewController (Fetches)

extension CoreDataQuizletTableViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
//    func executeTextSearch() {
//        if let fc = fetchedTextResultsController {
//            do {
//                try fc.performFetch()
//            } catch let e as NSError {
//                print("Error while trying to perform a search: \n\(e)\n\(fetchedTextResultsController)")
//            }
//        }
//    }
    
    
}

// MARK: - CoreDataCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataQuizletTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //about to make updates.  wrapping actions with updates will allow for animation and auto reloading
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let theQuizletSet = anObject as? QuizletSet {
            
            switch(type) {
            case .insert:
                //this will be done in the view controller so it can be selected
                setsToDisplay.append(theQuizletSet)
                
                //animate the insertion of new cells
                if let index = setsToDisplay.getIndex(of: theQuizletSet) {
                    let setIndexPath = IndexPath(row: index, section: 0)
                    tableView.insertRows(at: [setIndexPath], with: UITableViewRowAnimation.automatic)
                }
                
                print("case insert")
            case .delete:
                //TODO: Delete from table view
                removeFromSetsToDisplayByID(removeThisSet: theQuizletSet)
                tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                print("case delete")
            case .update:
                //nothing is needed here because when data is updated the tableView displays datas current state
                print("case update")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move")
            }
            
            //save
            stack.save()
            
            //TODO: Persist the text box
            
        } else
        {
            fatalError("Couldn't get a QuizletSet from anObject in didChange")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        self.tableView.endUpdates()
    }
    
    func removeFromSetsToDisplayByID(removeThisSet: QuizletSet) {
        for set in setsToDisplay {
            if set.id == removeThisSet.id {
                setsToDisplay.removeObject(object: set)
            }
        }
    }
}
