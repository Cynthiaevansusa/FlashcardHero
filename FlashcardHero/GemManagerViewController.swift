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
        
        //create FRC for TrackedGems
        _ = setupFetchedResultsController(frcKey: keyTrackedGems, entityName: "QuizletSet",
                                          sortDescriptors: [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)],
                                          predicate: nil)
        
        //if user is logged in setup the UsersGems FRC
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isUserLoggedIn() {
            self.setupUserGemsFRC()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
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
        UIView.animate(withDuration: 0.1, animations: {
            self.gemTableView.alpha = 1.0
            self.gemTableView.isHidden = false
            
        })
    }
    
    func showUserGemsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.gemTableView.alpha = 0.0
            self.gemTableView.isHidden = true
            
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
    /*************///MARK: - Appearance
    /******************************************************/
    
    func setViewForLoginStatus(_ loggedin: Bool) {
        if loggedin {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.isUserLoggedIn() {
                self.setupUserGemsFRC()
            }
            
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
        loginQuizletButton.title = "Log Out"
    }
    
    func setVeiwUserLoggedOut() {
        self.navigationItem.title = nil
        loginQuizletButton.title = "Log In"
    }
    
    /******************************************************/
    /*******************///MARK: QuizletSetSearchResultIngesterDelegate
    /******************************************************/

    func addToDataModel(_ QuizletSetSearchResults: [QuizletSetSearchResult]) {
        //take the array of QuizletSetSearchResults and add to CoreData
        let visibleFrcKey = getVisibleFrcKey()
        for searchResult in QuizletSetSearchResults {
            //TODO: add error checking
            
            //TODO: only add if not already in the model
            
            let newSet = QuizletSet(withQuizletSetSearchResult: searchResult, context: self.frcDict[visibleFrcKey]!.managedObjectContext)
            
            //download the terms
            newSet.fetchTermsAndAddTo(context: self.frcDict[visibleFrcKey]!.managedObjectContext)
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
        if let fc = self.frcDict[visibleFrcKey] {
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
        let visibleFrcKey = getVisibleFrcKey()
        let set = self.frcDict[visibleFrcKey]!.object(at: indexPath) as! QuizletSet
        
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
        guard self.segmentedControl.selectedSegmentIndex == 0 else {
            return
        }
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let context = self.frcDict[self.keyTrackedGems]?.managedObjectContext {
                
                context.delete(self.frcDict[self.keyTrackedGems]!.object(at: indexPath) as! QuizletSet)
 
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
        let visibleFrcKey = getVisibleFrcKey()
        let indexPath = self.tableView.indexPath(for: sender)
        let quizletSet = self.frcDict[visibleFrcKey]!.object(at: indexPath!) as! QuizletSet
        quizletSet.isActive = sender.activeSwitch.isOn
    }
    
    
    /******************************************************/
    /******************* Model Operations **************/
    /******************************************************/
    //MARK: - Model Operations
    
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
