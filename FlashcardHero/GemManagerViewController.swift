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
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    //FRCs
    let keyTrackedGems = "TrackedGems"
    let keyUsersGems = "UserGems"
    let keyPhotoSearchTermDefinitions = "PhotoSearchTermDefinitions"
    
    var gemInActiveFlux: QuizletSet?
    
    //pull to refresh
    //adapted from https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/#regular-view-controller
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        refreshControl.tag = 111
        return refreshControl
    }()
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()

        //set tableView
        tableView = gemTableView
        tableView.delegate = self
        tableView.dataSource = self
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        //if user is logged in setup the UsersGems FRC
        //TODO: change this to always be
        if delegate.isUserLoggedIn() {
            self.setupUserGemsFRC()
            
            //create FRC for TrackedGems
            _ = setupFetchedResultsController(frcKey: keyTrackedGems, entityName: "QuizletSet",
                                              sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],
                                              predicate: NSPredicate(format: "createdBy != %@", argumentArray: [delegate.getQuizletUserId()!]))
        } else {
            //setup main table without userid
            
            //create FRC for TrackedGems
            _ = setupFetchedResultsController(frcKey: keyTrackedGems, entityName: "QuizletSet",
                                              sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],
                                              predicate: nil)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tableView.reloadData()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        setViewForLoginStatus(delegate.isUserLoggedIn())
    }
    
    /******************************************************/
    /*******************///MARK: Segmented Control
    /******************************************************/
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            showTrackedGemsSegment()
        case 1:
            showUserGemsSegment()
        default:
            break;
        }
    }
    
    func showTrackedGemsSegment() {
        print("Switching to Tracked Gem Segment")
        
        //tagging and removing a subview
        //adapted from http://stackoverflow.com/questions/28197079/swift-addsubview-and-remove-it
        if let viewWithTag = self.view.viewWithTag(111) {
            viewWithTag.removeFromSuperview()
        }
        
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.1, animations: {
            //self.gemTableView.alpha = 1.0
            //self.gemTableView.isHidden = false
            
            
            
        })
    }
    
    func showUserGemsSegment() {
        print("Switching to User Gems Segment")
        //add the pull to refresh subview
        if self.view.viewWithTag(111) == nil {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.tableView.reloadData()
        
        //if there are no rows in the table, search to see if the user has any
        //TODO: Make a more sophisticated way to search every so often
        if tableView(self.tableView, numberOfRowsInSection: 0) < 1 {
            self.searchQuizletForUserSets()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            //self.gemTableView.alpha = 0.0
            //self.gemTableView.isHidden = true
            
            
            
        })
    }
    
    func getVisibleFrcKey() -> String{
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.keyTrackedGems
        } else {
            return self.keyUsersGems
        }
    }
    
    /******************************************************/
    /*******************///MARK: Pull to Refresh
    /******************************************************/

    /**
     When user pulls down on the table
     */
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        //search for sets again
        self.searchQuizletForUserSets()
        
        refreshControl.endRefreshing()
    }
    
    /******************************************************/
    /*************///MARK: - Appearance
    /******************************************************/
    
    func setViewForLoginStatus(_ loggedin: Bool) {
        if loggedin {
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            if delegate.isUserLoggedIn() {
//                self.setupUserGemsFRC()
//            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.setViewUserLoggedIn()
                self.segmentedControl.setEnabled(true, forSegmentAt: 1)
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.setVeiwUserLoggedOut()
                self.segmentedControl.setEnabled(false, forSegmentAt: 1)
            })
        }
    }
    
    func setViewUserLoggedIn() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let userId = delegate.getQuizletUserId()
        self.navigationItem.title = "Logged in as " + String(describing: userId)
        //loginQuizletButton.title = "Log Out"
        loginQuizletButton.image = UIImage(named:"UserSelectedIcon")
    }
    
    /**
     Handles housekeeping for when user is logged out
     */
    func setVeiwUserLoggedOut() {
        self.navigationItem.title = nil
        //loginQuizletButton.title = "Log In"
        loginQuizletButton.image = UIImage(named:"UserIcon")
    }
    
    /******************************************************/
    /*******************///MARK: QuizletSetSearchResultIngesterDelegate
    /******************************************************/

    func addToDataModel(QuizletSetSearchResults: [QuizletSetSearchResult]) {
        //take the array of QuizletSetSearchResults and add to CoreData
        let visibleFrcKey = getVisibleFrcKey()
        for searchResult in QuizletSetSearchResults {
            //TODO: add error checking
            
            //TODO: only add if not already in the model
            if let fc = self.frcDict[visibleFrcKey] {
                var didFindThisSet = false
                for set in (fc.sections?[0].objects)! {
                    let set = set as! QuizletSet
                    if set.id == Int64(searchResult.id!) {
                        didFindThisSet = true
                    }
                }
                if !didFindThisSet { //only add if didn't find this set already in frc
                    
                    let newSet = QuizletSet(withQuizletSetSearchResult: searchResult, context: self.frcDict[visibleFrcKey]!.managedObjectContext)
                    
                    //download the terms
                    newSet.fetchTermsAndAddTo(context: self.frcDict[visibleFrcKey]!.managedObjectContext, sender: self)
                } else {
                    //TODO: tell user the set is already being tracked
                }
            }
            
            //TODO: Remove sets that are not in this search result
            
            
        }
        
    }
    
    func addToDataModel(QuizletGetSetTermsResults: [QuizletGetSetTermsResult]) {
        //take the array of QuizletSetSearchResults and add to CoreData
        let visibleFrcKey = getVisibleFrcKey()
        for setTerm in QuizletGetSetTermsResults {
            //TODO: add error checking
            
            //only add if not already in the model
            if let fc = self.frcDict[visibleFrcKey] {
                var didFindThisSet = false
                for set in (fc.sections?[0].objects)! {
                    let set = set as! QuizletSet
                    if set.id == Int64(setTerm.set!.id!) {
                        didFindThisSet = true
                    }
                }
                if !didFindThisSet { //only add if didn't find this set already in frc
                
                    let newSet = QuizletSet(withQuizletSetSearchResult: setTerm.set!, context: self.frcDict[visibleFrcKey]!.managedObjectContext)
                    print("Added a new set: \(newSet) to context of \(visibleFrcKey)")
                    
                    //add the terms
                    for term in setTerm.terms {
                        _ = QuizletTermDefinition(withQuizletTermResult: term, relatedSet: newSet, context: self.frcDict[visibleFrcKey]!.managedObjectContext)
                    }
                } else {
                    //found the set, so check each term
                    //TODO: check each term to see if it needs to be replaced or updated
                }
            }
        }
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDelegate
    /******************************************************/
    //when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //present the collection view
        let visibleFrcKey = getVisibleFrcKey()

        let vc = storyboard?.instantiateViewController(withIdentifier: "GemTermsCollectionViewController") as! GemTermsCollectionViewController
        let theQuizletSet = self.frcDict[visibleFrcKey]!.object(at: indexPath) as! QuizletSet
        vc.quizletSet = theQuizletSet
        
        present(vc, animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDataSource
    /******************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("There are ", String(self.setsToDisplay.count), " sets to display")
        //return self.setsToDisplay.count
        let visibleFrcKey = getVisibleFrcKey()
        guard let fc = self.frcDict[visibleFrcKey] else {
            fatalError("Couldn't get fetchedResultsController with key \(visibleFrcKey)")
        }
        guard let sections = fc.sections else {
            fatalError("No sections in fetchedResultsController")
        }
    
        //print("Here is the frcDict \(frcDict)")
        //print("Here are all of the sets \(frcDict[visibleFrcKey]!.sections![section].objects)")
        
        let numRows = sections[section].numberOfObjects
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: replace as! UITAbleViewCell witha  custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GemManagerCell", for: indexPath as IndexPath) as! CustomGemManagerCell
        
        configureCell(cell: cell, indexPath: indexPath)

        return cell
    }
    
    /**
     used to set up the way a cell will look in the tableView
     */
    override func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
        //TODO: Fix bug where old images are present before loading new ones
        
        let visibleFrcKey = getVisibleFrcKey()

        guard let set = self.frcDict[visibleFrcKey]!.object(at: indexPath) as? QuizletSet else { fatalError("Unexpected Object in FetchedResultsController") }
        
        guard let cell = cell as? CustomGemManagerCell else { fatalError("Unexpected Cell") }
        // Populate cell from the NSManagedObject instance
        
        
        //associate the photo with this cell, which will set all parts of image view
        cell.quizletSet = set
        cell.cellDelegate = self
        
        if set.isLoadingTerms {
            cell.startActivityIndicator()
        } else {
            cell.stopActivityIndicator()
            //if we found an image, set it or else hide the imageView
            if let foundData = set.thumbnailImageData as? Data {
                cell.customImageView.image = UIImage(data: foundData)
                
            } else {
                cell.customImageView.image = nil
            }
        }
        
        if cell.customImageView.image != nil {
            cell.customImageView.isHidden = false
            cell.customImageView.alpha = 1
        } else {
            cell.customImageView.isHidden = true
            cell.customImageView.alpha = 0
        }
    }
    
    //editing is allowed for anonymous sets
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let visibleFrcKey = getVisibleFrcKey()
        if visibleFrcKey == self.keyUsersGems {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard self.segmentedControl.selectedSegmentIndex == 0 else {
            return
        }
        switch editingStyle {
        case .delete:
            
            let visibleFrcKey = getVisibleFrcKey()
            if let context = self.frcDict[visibleFrcKey]?.managedObjectContext {
                
                //TODO: Warn use that all performance data will also be deleted.  If they accept, then delete.
                
                context.delete(self.frcDict[self.keyTrackedGems]!.object(at: indexPath) as! QuizletSet)
                // Get the stack
                let delegate = UIApplication.shared.delegate as! AppDelegate
                stack = delegate.stack
                stack.save()
            }
            
        default:
            return
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
        let visibleFrcKey = getVisibleFrcKey()
        let indexPath = self.tableView.indexPath(for: sender)
        let quizletSet = self.frcDict[visibleFrcKey]!.object(at: indexPath!) as! QuizletSet
        quizletSet.isActive = sender.activeSwitch.isOn
    }
    
    
    /******************************************************/
    /******************* Model Operations **************/
    /******************************************************/
    //MARK: - Model Operations
    
    func searchQuizletForUserSets() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        guard delegate.isUserLoggedIn() else {
            print("User is not logged in, cannot get the user's sets")
            return
        }
        
        let userId = delegate.getQuizletUserId()!
        
        GCDBlackBox.runNetworkFunctionInBackground {
            QuizletClient.sharedInstance.getQuizletSetTermsBy(userId: userId) { (results, error) in
                GCDBlackBox.performUIUpdatesOnMain {
                    
                    print("Reached CompletionHandler of getQuizletSearchSetsBy userId")
                    //print("results: \(results)")
                    //print("error: \(error)")
                    
                    
                    
                    if error == nil && results != nil {
                        print("User sets search success")
                        
                        //self.userSetsTemp = []
                        //self.userSetsTemp.append(contentsOf: results!)
                        //print("There are \(self.userSetsTemp.count) sets about to be added to the model")
                        self.addToDataModel(QuizletGetSetTermsResults: results!)
                        
                        //print("contents of search results: \(self.searchResults)")
                        //self.tableView.reloadData()
                    } else {
                        //TODO: handle error
                    }
                }//end of performUIUpdatesOnMain
            } //end of getQuizletSearchSetsBy
        }//end of runNetworkFunctionInBackground
    }
    
    func setupUserGemsFRC() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let userId = delegate.getQuizletUserId()
        
        if let userId = userId {
            _ = setupFetchedResultsController(frcKey: keyUsersGems, entityName: "QuizletSet",
                                              sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],
                                              predicate: NSPredicate(format: "createdBy = %@", argumentArray: [userId]))
        }
    }
    
    
    func fetchModelQuizletSets() -> [QuizletSet] {
        let visibleFrcKey = getVisibleFrcKey()
        return self.frcDict[visibleFrcKey]!.fetchedObjects as! [QuizletSet]
    }

}
