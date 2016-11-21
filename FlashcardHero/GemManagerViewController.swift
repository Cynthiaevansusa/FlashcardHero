//
//  GemManagerViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/30/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GemManagerViewController: CoreDataQuizletTableViewController, UITableViewDataSource,  QuizletSetSearchResultIngesterDelegate, SettingCellDelegate {

    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/

    @IBOutlet weak var gemTableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var loginQuizletButton: UIBarButtonItem!

    var gemInActiveFlux: QuizletSet?
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()

        //set tableView
        tableView = gemTableView
        tableView.delegate = self
        tableView.dataSource = self
        
        setupFetchedResultsController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    /******************************************************/
    /*******************///MARK: QuizletSetSearchResultIngesterDelegate
    /******************************************************/

    func addToDataModel(_ QuizletSetSearchResults: [QuizletSetSearchResult]) {
        //take the array of QuizletSetSearchResults and add to CoreData
        
        for searchResult in QuizletSetSearchResults {
            //TODO: add error checking
            
            let newSet = QuizletSet(withQuizletSetSearchResult: searchResult, context: self.fetchedResultsController!.managedObjectContext)
            
            //download the terms
            newSet.fetchTermsAndAddTo(context: self.fetchedResultsController!.managedObjectContext)
        }
        
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDelegate
    /******************************************************/
    //when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //present the collection view
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GemTermsCollectionViewController") as! GemTermsCollectionViewController
        let theQuizletSet = self.fetchedResultsController!.object(at: indexPath) as! QuizletSet
        vc.quizletSet = theQuizletSet
        
        present(vc, animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDataSource
    /******************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: replace as! UITAbleViewCell witha  custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GemManagerCell", for: indexPath as IndexPath) as! CustomGemManagerCell
        let set = self.fetchedResultsController!.object(at: indexPath) as! QuizletSet
        
        //associate the photo with this cell, which will set all parts of image view
        cell.quizletSet = set
        cell.cellDelegate = self
        
//        if photo.isTransitioningImage {
//            cell.startActivityIndicator()
//        } else {
//            cell.stopActivityIndicator()
//        }
        
        return cell
    }
    
    //editing is allowed
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let context = fetchedResultsController?.managedObjectContext {
                
                context.delete(self.fetchedResultsController!.object(at: indexPath) as! QuizletSet)
 
            }
        }
    }
    
    /******************************************************/
    /*******************///MARK: Actions
    /******************************************************/

    @IBAction func addButtonPressed() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "QuizletSearchResultsViewController") as! QuizletSearchResultsViewController
        vc.quizletIngestDelegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginQuizletButtonPressed(_ sender: AnyObject) {
        QuizletClient.sharedInstance.sendUserToQuizletOAuth()
    }
    

    
    /******************************************************/
    /*******************///MARK: SettingCellDelegate
    /******************************************************/

    func didChangeSwitchState(sender: CustomGemManagerCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let quizletSet = self.fetchedResultsController!.object(at: indexPath!) as! QuizletSet
        quizletSet.isActive = sender.activeSwitch.isOn
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
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizletSet")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
//        let pred = NSPredicate(format: "pin = %@", argumentArray: [self.pin!])
//        
//        fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = fc
        
    }
    
    func fetchModelQuizletSets() -> [QuizletSet] {
        return fetchedResultsController!.fetchedObjects as! [QuizletSet]
    }

}
