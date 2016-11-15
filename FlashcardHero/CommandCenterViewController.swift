//
//  FirstViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
//import Charts

class CommandCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var missionsTableView: UITableView!
    
    
    @IBOutlet weak var playTrueFalseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            if let context = fetchedResultsController?.managedObjectContext {
//                
//                context.delete(self.fetchedResultsController!.object(at: indexPath) as! QuizletSet)
//                
//            }
//        }
//    }
    
    
    
    
    @IBAction func playTrueFalseButtonPressed(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameTrueFalse")
        //vc.quizletIngestDelegate = self
        
        present(vc!, animated: true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

