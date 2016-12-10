//
//  QuizletSearchResultsViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/30/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

//this protocol allows the QuizletSearchResultsViewController to send results back without doing the CoreData stuff itself
protocol QuizletSetSearchResultIngesterDelegate: class {
    func addToDataModel(QuizletSetSearchResults: [QuizletSetSearchResult])
}

class QuizletSearchResultsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchResults = [QuizletSetSearchResult]()

    var quizletIngestDelegate: QuizletSetSearchResultIngesterDelegate?
    
    var searchAttempts = 0
    
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
    /*******************///MARK: Utilities
    /******************************************************/
    func startActivityIndicator() {
        self.activityIndicator!.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator!.stopAnimating()
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
        let setsToSendToCoreData = createResultsArrayFromSelected()
        
        //print("Done pressed.  Will pass these objects to CoreData: \(setsToSendToCoreData)")
        if let delegate = self.quizletIngestDelegate {
            delegate.addToDataModel(QuizletSetSearchResults: setsToSendToCoreData)
        } else {
            //TODO: Handle issue where there was no delegate
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDoneButton(enabled: Bool) {
        doneButton.isEnabled = enabled
    }
    
    func createResultsArrayFromSelected() -> [QuizletSetSearchResult] {
        var arrayOfResults = [QuizletSetSearchResult]()
        
        //check for nil
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                arrayOfResults.append(searchResults[indexPath.row])
            }
        }
        
        return arrayOfResults
    }
    
    /******************************************************/
    /*******************///MARK: QuizletAPI
    /******************************************************/

    func searchQuizletFor(searchTerm: String) {
        
        self.startActivityIndicator()
        GCDBlackBox.runNetworkFunctionInBackground {
            QuizletClient.sharedInstance.getQuizletSearchSetsBy(searchTerm) { (results, error) in
                GCDBlackBox.performUIUpdatesOnMain {
                    
                    print("Reached CompletionHandler of getQuizletSearchSetsBy")
                    //print("results: \(results)")
                    //print("error: \(error)")
                    
                    self.stopActivityIndicator()
                    
                    if error == nil {
                        print("Search success")

                        for set in results! {
                            self.searchResults.append(set)
                        }
                        //print("contents of search results: \(self.searchResults)")
                        self.tableView.reloadData()
                    } else if self.searchAttempts < 2 {
                        //search again
                        self.searchAttempts += 1
                        print("Retrying search for quizlet results, search try \(self.searchAttempts)")
                        self.searchQuizletFor(searchTerm: searchTerm)
                    } else {
                        self.searchAttempts = 0
                        //tried twice, give user an error
                        
                        alertGenericNetworkError(vc: self, errorString: (error?.localizedDescription)!)
                        
                    }
                }//end of performUIUpdatesOnMain
            } //end of getQuizletSearchSetsBy
        }//end of runNetworkFunctionInBackground
    }

}
