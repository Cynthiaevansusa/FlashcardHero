//
//  CoreDataQuizletCollectionViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/3/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataQuizletCollectionViewController: UIViewController, UICollectionViewDelegate {
    
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
    
    
    
    var collectionView: UICollectionView!
    
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
    /******************* UIcollectionViewDelegate Delegate and Data Source **************/
    /******************************************************/
    //MARK: - UIcollectionViewDelegate Delegate and Data Source
    
    
    //When a user selects an item from the collection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("This stub should be implimented by a child class")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("This stub should be implimented by a child class")
    }
    
}

// MARK: - CoreDataCollectionViewController (Fetches)

extension CoreDataQuizletCollectionViewController {
    
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

extension CoreDataQuizletCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //about to make updates.  wrapping actions with updates will allow for animation and auto reloading
        //self.collectionView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if anObject is QuizletTermDefinition {
            
            switch(type) {
            case .insert:
                //from apple documentation
                
                self.collectionView.insertItems(at: [newIndexPath!])
                
                //TODO: initiate download of terms?
                
                print("case insert")
            case .delete:
                //from apple documentation
                self.collectionView.deleteItems(at: [indexPath!])
                
                print("case delete")
            case .update:
                //from apple documentation
                
                //nothing is needed here because when data is updated the collectionView displays datas current state
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
            fatalError("Couldn't get a QuizletTermDefinition from anObject in didChange")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //finished with updates, allow table view to animate and reload
        //self.collectionView.endUpdates()
        self.collectionView!.reloadData()
    }
}
