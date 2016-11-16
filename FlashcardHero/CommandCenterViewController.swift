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
    
    
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    @IBOutlet weak var statsOverviewView: UIView!
    @IBOutlet weak var statsNumAppSessions: UILabel!
    var statsNumAppSessionsFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            statsNumAppSessionsFetchedResultsController?.delegate = self
            executeStatsNumAppSessionsSearch()
        }
    }
    @IBOutlet weak var statsNumStudySessions: UILabel!
    var statsNumStudySessionsFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            statsNumStudySessionsFetchedResultsController?.delegate = self
            executeStatsNumStudySessionsSearch()
        }
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showMissionsSegment()
        setupAppSessionsAndSet()
        setupStudySessionsAndSet()

    }
    
    /******************************************************/
    /*******************///MARK: NumStudySessions
    /******************************************************/
    
    func setupStudySessionsAndSet(){
        setupStatsNumStudySessionsFetchedResultsController()
        setStatsNumStudySessions()
    }
    
    func executeStatsNumStudySessionsSearch() {
        if let fc = statsNumStudySessionsFetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(statsNumStudySessionsFetchedResultsController)")
            }
        }
    }
    
    func setupStatsNumStudySessionsFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "StudySession")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        
        //only return where isActive is set to true
        //let pred = NSPredicate(format: "isActive = %@", argumentArray: [true])
        
        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.statsNumStudySessionsFetchedResultsController = fc
        
    }
    
    func setStatsNumStudySessions() {
        
        if let studySessions = self.statsNumStudySessionsFetchedResultsController?.fetchedObjects {
            
            self.statsNumStudySessions.text = String(studySessions.count)
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no studySessions, setting numStudySessions to zero")
            self.statsNumStudySessions.text = String(0)
        }
    }

    
    /******************************************************/
    /*******************///MARK: NumAppSessions
    /******************************************************/

    func setupAppSessionsAndSet(){
        setupStatsNumAppSessionsFetchedResultsController()
        setStatsNumAppSessions()
    }
    
    func executeStatsNumAppSessionsSearch() {
        if let fc = statsNumAppSessionsFetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(statsNumAppSessionsFetchedResultsController)")
            }
        }
    }
    
    func setupStatsNumAppSessionsFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSession")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        
        //only return where isActive is set to true
        //let pred = NSPredicate(format: "isActive = %@", argumentArray: [true])
        
        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.statsNumAppSessionsFetchedResultsController = fc
        
    }
    
    func setStatsNumAppSessions() {
        
        if let sessions = self.statsNumAppSessionsFetchedResultsController?.fetchedObjects {
            
            self.statsNumAppSessions.text = String(sessions.count)
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no sessions, setting numAppSessions to zero")
            self.statsNumAppSessions.text = String(0)
        }
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
            showStatsSegment()
        case 2:
            showGoalsSegment()
        default:
            break; 
        }
    }
    
    func showMissionsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsTableView.alpha = 1.0
            self.missionsTableView.isHidden = false
            
            self.statsView.alpha = 0.0
            self.statsView.isHidden = true
        })
    }
    
    func showStatsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsTableView.alpha = 0.0
            self.missionsTableView.isHidden = true
            
            
            self.refreshStats()
            self.statsView.alpha = 1.0
            self.statsView.isHidden = false
        })
    }
    
    func showGoalsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsTableView.alpha = 0.0
            self.missionsTableView.isHidden = true
            
            self.statsView.alpha = 0.0
            self.statsView.isHidden = true
        })
    }
    
    func refreshStats() {
        setStatsNumAppSessions()
        setStatsNumStudySessions()
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

