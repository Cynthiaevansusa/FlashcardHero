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
    
    var searchResults = NSMutableArray()

    
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
    /*******************///MARK: TableViewDataSource Delegate
    /******************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("From cellForRowAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizletSearchCell")!
//        let StudentInformation = self.StudentInformations[(indexPath as NSIndexPath).row]
//        
//        // Set the name and image
        cell.textLabel?.text = String(describing: searchResults[indexPath.row])
        //cell.detailTextLabel?.text = (StudentInformation.mediaURL! as String)
//
//        //color it crazy
//        cell.imageView?.backgroundColor = colorButton.getRandoColor()
        
        return cell
    }
    
    /******************************************************/
    /*******************///MARK: SearchBar Delegate
    /******************************************************/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("Search button clicked")
        
        if let searchTerm = searchBar.text {
            searchQuizletFor(searchTerm: searchTerm)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: QuizletAPI
    /******************************************************/

    func searchQuizletFor(searchTerm: String) {
        QuizletClient.sharedInstance.getQuizletSearchSetsBy(searchTerm) { (results, error) in
            
            print("Reached CompletionHandler of getQuizletSearchSetsBy")
            print("results: \(results)")
            print("error: \(error)")
            
            
            
            if error == nil {
                print("Search success")
                
                for set in results! {
                    print(set)
                    if let setDictionary = set as? [String:Any] {
                        self.searchResults.add(setDictionary["id"]! as! Int)
                    }
                    
                }
                print(self.searchResults)
                self.tableView.reloadData()
            }
            
        }
    }
}
