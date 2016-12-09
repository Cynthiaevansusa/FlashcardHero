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

class CoreDataQuizletTableViewController: CoreDataViewController, UITableViewDelegate {
    
    /******************************************************/
    /******************* Properties **************/
    /******************************************************/
    //MARK: - Properties
        var tableView: UITableView!
    
//    var stack: CoreDataStack!
    
    /******************************************************/
    /******************* Life Cycle **************/
    /******************************************************/
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

// MARK: - CoreDataCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataQuizletTableViewController {
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        print("Stub for configureCell should be implimented by a child class")
    }
    
    override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //about to make updates.  wrapping actions with updates will allow for animation and auto reloading
        self.tableView.beginUpdates()
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("\(controller) didChange anObject")
        //save
        //stack.save()
        
        if anObject is QuizletSet {
            
            switch(type) {
            case .insert:
                stack.save()
                //from apple documentation
                self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
                
                print("case insert")
            case .delete:
                //from apple documentation
                self.tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                print("case delete")
            case .update:
                stack.save()
                //from apple documentation
                configureCell(cell: tableView.cellForRow(at: indexPath!)!, indexPath: indexPath!)
                print("case update")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move")
            }
          
        } else
        {
            fatalError("Couldn't get a QuizletSet from anObject in didChange")
        }
        
        
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        //print("\(controller) didchangecontent")
        self.tableView.endUpdates()
    }
}
