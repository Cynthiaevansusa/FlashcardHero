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
    
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
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
        
        creatorName.text = quizletSet.createdBy
        setTitle.text = quizletSet.title
        
    }
    
    /******************************************************/
    /*******************///MARK: UICollectionView
    /******************************************************/
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        let space: CGFloat!
//        let dimension: CGFloat!
//        
//        //following layout approach adapted from
//        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) { //If portrait mode
//            //implement flow layout
//            space = 3.0
//            // have 1 items across if in portrait
//            let numberOfItems: CGFloat = 1
//            let spacingConstant: CGFloat = numberOfItems - 1
//            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
//        } else { //if not in portrait mode
//            //implement flow layout
//            space = 1.0
//            // have 2 items across if in not portrait
//            let numberOfItems: CGFloat = 2
//            let spacingConstant: CGFloat = numberOfItems - 1
//            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
//        }
//        //set the flowLayout based on new values
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = space
//        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space*2+2, right: space)
//        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
//    }
    
    /******************************************************/
    /*******************///MARK: Toolbars
    /******************************************************/
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
    }
    
    /******************************************************/
    /*******************///MARK: UICollectionViewDataSource
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
        cell.definition.text = term.definition
        
        
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
        
        fr.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        
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
