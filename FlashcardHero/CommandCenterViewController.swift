//
//  FirstViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
import CoreData
//import Charts

class CommandCenterViewController: CoreDataViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var missionsTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showMissionsSegment()

    }

    
    
    /******************************************************/
    /*******************///MARK: Segmented Control
    /******************************************************/

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            showMissionsSegment()
        case 1:
            showGoalsSegment()
        default:
            break; 
        }
    }
    
    func showMissionsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsTableView.alpha = 1.0
            self.missionsTableView.isHidden = false

        })
    }
    
    func showGoalsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsTableView.alpha = 0.0
            self.missionsTableView.isHidden = true
 
        })
    }

    
    
    
    /******************************************************/
    /*******************///MARK: UITableViewDelegate
    /******************************************************/
    //when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let gameStoryboardId = GameDirectory.activeGames[indexPath.row].storyboardId
        
        let vc = storyboard?.instantiateViewController(withIdentifier: gameStoryboardId)
        //vc.quizletIngestDelegate = self
        
        present(vc!, animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: UITableViewDataSource
    /******************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("There are ", String(self.setsToDisplay.count), " sets to display")
        //return self.setsToDisplay.count
        return GameDirectory.activeGames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: replace as! UITAbleViewCell witha  custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath as IndexPath)
        
        //associate the photo with this cell, which will set all parts of image view
        cell.textLabel!.text = GameDirectory.activeGames[indexPath.row].name
        if let description = GameDirectory.activeGames[indexPath.row].description {
            cell.detailTextLabel!.text = description
        } else {
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
    
    //editing is not allowed
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

