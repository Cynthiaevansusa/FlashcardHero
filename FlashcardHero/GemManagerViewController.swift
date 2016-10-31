//
//  GemManagerViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/30/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class GemManagerViewController: UITableViewController, UISearchBarDelegate {

    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

    }
    
    
    /******************************************************/
    /*******************///MARK: Search Button
    /******************************************************/

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        segueSearch(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
        
    }
    
    func segueSearch(_ searchBar: UISearchBar) {
        print("searching for \(searchBar.text)")
        
        self.performSegue(withIdentifier: "QuizletSearchResults", sender: self)
    }

}
