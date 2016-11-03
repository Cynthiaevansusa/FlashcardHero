//
//  GemTermsCollectionViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/3/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GemTermsCollectionViewController: CoreDataQuizletCollectionViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var gemCollectionView: UICollectionView!
    
    var quizletSet: QuizletSet!
    
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tableView
        collectionView = gemCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupFetchedResultsController()
        
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDataSource
    /******************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("There are ", String(self.setsToDisplay.count), " sets to display")
        //return self.setsToDisplay.count
        if let fc = fetchedResultsController {
            if (fc.sections?.count)! > 0 {
                let sectionInfo = fc.sections?[section]
                return (sectionInfo?.numberOfObjects)!
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO: replace as! UITAbleViewCell witha  custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GemTermsCell", for: indexPath as IndexPath) as! CustomGemTermsCollectionViewCell
        let term = self.fetchedResultsController!.object(at: indexPath) as! QuizletTermDefinition
        
        //associate the photo with this cell, which will set all parts of image view
        //cell.quizletSet = set
        //cell.cellDelegate = self
        
        //        if photo.isTransitioningImage {
        //            cell.startActivityIndicator()
        //        } else {
        //            cell.stopActivityIndicator()
        //        }
        cell.term.text = term.term
        
        
        return cell
    }
    
    /******************************************************/
    /******************* Model Operations **************/
    /******************************************************/
    //MARK: - Model Operations
    
    func setupFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizletTermDefinition")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: false)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
                let pred = NSPredicate(format: "quizletSet = %@", argumentArray: [self.quizletSet])
        
                fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = fc
        
    }
    
}
