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
    
    let keyGemTerms = "GemTerms"
    
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
        
        //setupFetchedResultsController()      
        _ = setupFetchedResultsController(frcKey: keyGemTerms, entityName: "QuizletTermDefinition", sortDescriptors: [NSSortDescriptor(key: "rank", ascending: true)],  predicate: NSPredicate(format: "quizletSet = %@", argumentArray: [self.quizletSet]))

        creatorName.text = quizletSet.createdBy
        setTitle.text = quizletSet.title
        
    }
    
    
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
        if let fc = frcDict[keyGemTerms] {
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
        let term = frcDict[keyGemTerms]!.object(at: indexPath) as! QuizletTermDefinition
        
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
    
}
