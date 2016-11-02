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

class GemManagerViewController: CoreDataQuizletTableViewController, UITableViewDataSource, QuizletSetSearchResultIngesterDelegate, SettingCellDelegate {

    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/

    @IBOutlet weak var gemTableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!

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
        
        //load data to table if there is any
        setupTableView()
        
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
            let newQuizletSet = QuizletSet(withQuizletSetSearchResult: searchResult, context: self.fetchedResultsController!.managedObjectContext)
            //setsToDisplay.append(newQuizletSet)
        }
        
        setupTableView()
        
        print("Got sets from the search.  sets are: \(setsToDisplay)")
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDataSource
    /******************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are ", String(self.setsToDisplay.count), " sets to display")
        return self.setsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: replace as! UITAbleViewCell witha  custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GemManagerCell", for: indexPath as IndexPath) as! CustomGemManagerCell
        let set = self.setsToDisplay[indexPath.row]
        
        //associate the photo with this cell, which will set all parts of image view
        cell.quizletSet = set
        cell.cellDelegate = self
        //using switches in table view adapted from
        //http://stackoverflow.com/questions/3770019/uiswitch-in-a-uitableview-cell
        //cell.activeSwitch.addTarget(self, action: #selector(GemManagerViewController.activeSwitchToggled(_:)), for: UIControlEvents.valueChanged)
        
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
                //animate deletion.  adapted from
                // http://stackoverflow.com/questions/31365253/delete-table-row-with-animation
                
                context.delete(setsToDisplay[indexPath.row])
                
                
                //self.tableView.reloadData()
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
    
//    func activeSwitchToggled(_ sender: UISwitch) {
//        sender.setOn(sender.isOn, animated: true)
//        print("Switch is \(sender.isOn)")
//        
//        //adapted from http://stackoverflow.com/questions/31707335/how-do-i-change-a-switch-in-coredata-using-dynamic-tables-swift
//        let point = sender.convert(CGPoint.zero, to: tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//        let quizletSet = fetchedResultsController?.object(at: indexPath!) as! QuizletSet
//        quizletSet.isActive = sender.isOn
//
//    }
    
    /******************************************************/
    /*******************///MARK: SettingCellDelegate
    /******************************************************/

    func didChangeSwitchState(sender: CustomGemManagerCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let quizletSet = setsToDisplay[indexPath!.row]
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
    
    func setupTableView() {
        //if there are stored QuizletSets in the model, load them into the collection view
        setsToDisplay = fetchModelQuizletSets()
        
        //if the contents is empty, the load some contents
//        if setsToDisplay.count < 1 {
//            flickrGetPhotosNearPin(radius: 5.0, tryAgain: true)
//        }
        
        
    }

}
