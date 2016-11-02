//
//  QuizletSearchResultsViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/30/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class QuizletSearchResultsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var searchResults = [QuizletSetSearchResult]()

    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        //searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //put focus to the search bar
        searchBar.becomeFirstResponder()
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDelegate
    /******************************************************/

    //when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check if the Done button needs be enabled
        if !doneButton.isEnabled {
            setDoneButton(enabled: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //check to see if Done button needs to be disabled
        if doneButton.isEnabled && tableView.indexPathsForSelectedRows == nil {
            setDoneButton(enabled: false)
        }
    }
    
    /******************************************************/
    /*******************///MARK: TableViewDataSource Delegate
    /******************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("From cellForRowAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizletSearchCell")! as! CustomQuizletSearchBySetsResultsCell
//        let StudentInformation = self.StudentInformations[(indexPath as NSIndexPath).row]
//        
//      // Set the name and image
        cell.quizletSetSearchResult = searchResults[indexPath.row]
        
        return cell
    }
    
    /******************************************************/
    /*******************///MARK: SearchBar Delegate
    /******************************************************/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("Search button clicked")
        
        clearSearchResults()
        
        if let searchTerm = searchBar.text {
            searchQuizletFor(searchTerm: searchTerm)
        }
        
    }
    
    func clearSearchResults() {
        searchResults.removeAll()
    }
    
    /******************************************************/
    /*******************///MARK: Toolbar
    /******************************************************/

    @IBAction func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed() {
        //save the selected rows as core data objects.
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDoneButton(enabled: Bool) {
        doneButton.isEnabled = enabled
    }
    
    /******************************************************/
    /*******************///MARK: QuizletAPI
    /******************************************************/

    func searchQuizletFor(searchTerm: String) {
        GCDBlackBox.runNetworkFunctionInBackground {
            QuizletClient.sharedInstance.getQuizletSearchSetsBy(searchTerm) { (results, error) in
                GCDBlackBox.performUIUpdatesOnMain {
                    
                    print("Reached CompletionHandler of getQuizletSearchSetsBy")
                    //print("results: \(results)")
                    //print("error: \(error)")
                    
                    
                    
                    if error == nil {
                        print("Search success")
                        
                        
                        
                        for set in results! {
                            //print(set)
                            if let setDictionary = set as? [String:AnyObject] {
                                                        
                                do {
                                    if let quizletResult = try QuizletSetSearchResult(fromDataSet: setDictionary) {
                                        self.searchResults.append(quizletResult)
                                    }
                                    
                                }
                                catch {
                                    //TODO: handle error
                                    print("Error when creating quizletResult")
                                }
                                
                                //self.searchResults.add(setDictionary["id"]! as! Int)
                            }
                            
                        }
                        //print("contents of search results: \(self.searchResults)")
                        self.tableView.reloadData()
                    } else {
                        //TODO: handle error
                    }
                }//end of performUIUpdatesOnMain
            } //end of getQuizletSearchSetsBy
        }//end of runNetworkFunctionInBackground
    }
}
