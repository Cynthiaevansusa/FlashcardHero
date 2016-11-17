//
//  AnalysisViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
import CoreData
//import Charts

class AnalysisViewController: CoreDataQuizletCollectionViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var statsOverviewCollectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

//    var statsQuestionAttemptsFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
//        didSet {
//            statsQuestionAttemptsFetchedResultsController?.delegate = self
//            executeSearch(frcKey: keyQuestionAttempts)
//        }
//    }
    
    var statsNumAppSessionsFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            statsNumAppSessionsFetchedResultsController?.delegate = self
            executeStatsNumAppSessionsSearch()
        }
    }
    
    var statsNumStudySessionsFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            statsNumStudySessionsFetchedResultsController?.delegate = self
            executeStatsNumStudySessionsSearch()
        }
    }
    
    var frcDict : [String:NSFetchedResultsController<NSFetchRequestResult>] = [:]
    let keyMissions = "Missions"
    let keyAppSessions = "App Sessions"
    let keyQuestionAttempts = "Question Attempts"
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var statsOverviewItems: [String:OverviewStatistic] = [:]
    var statsOverviewCollectionData: [OverviewStatistic] = []
    
    var orderDict: [String:Int] = [:]
    var entityDict: [String:String] = [:]
    var searchDict: [String:String] = [:]
    
    let orderAppSessions = 0
    let orderStudySessions = 1
    let orderQuestionAttempts = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView = statsOverviewCollectionView
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        orderDict = [keyMissions : 1,
        keyAppSessions : 0,
        keyQuestionAttempts : 2]
//        
//        entityDict = [keyMissions : "",
//                     keyAppSessions : "",
//                     keyQuestionAttempts : "TDPerformanceLog"]
//        
//        searchDict = [keyMissions : "",
//                      keyAppSessions : "",
//                      keyQuestionAttempts : "datetime"]
        
        self.setupAppSessionsAndSet()
        self.setupStudySessionsAndSet()
        
        setupFetchedResultsController(entityName: "TDPerformanceLog", sortKey: "datetime", frcKey: keyQuestionAttempts)
        setStats(frcKey: keyQuestionAttempts)
        
//        frcDict = [keyMissions: self.statsNumStudySessionsFetchedResultsController!,
//        keyAppSessions: self.statsNumAppSessionsFetchedResultsController!,
//        keyQuestionAttempts: self.statsQuestionAttemptsFetchedResultsController!]
        
        
        showOverviewSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshStats()
    }
    
    /******************************************************/
    /*******************///MARK: UICollectionViewDataSource
    /******************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("There are ", String(self.setsToDisplay.count), " sets to display")
        //If segment 0 is showing
        if segmentedControl.selectedSegmentIndex == 0 {
            return statsOverviewItems.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
            //TODO: replace as! UITAbleViewCell witha  custom cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statOverviewCell", for: indexPath as IndexPath) as! CustomStatsOverviewCell
            let stat = self.statsOverviewCollectionData[indexPath.row] 
        
            cell.statDescription.text = stat.description
            cell.statNumber.text = String(stat.number)
            
            
            return cell
//        default: break
//            
//        }
    }
    
    func insertOverviewStatisticIntoStatsOverviewItems(_ stat: OverviewStatistic) {
        statsOverviewItems[stat.description] = stat
        generateStatsOverviewCollectionData()
    }
    
    //take the statsOverviewItems and create an array ordered on order
    func generateStatsOverviewCollectionData() {
        var newArray: [OverviewStatistic] = []
        for stat in statsOverviewItems {
            newArray.append(stat.value)
        }
        statsOverviewCollectionData = newArray.sorted(by: { $0.order < $1.order})
        //collectionView.reloadData()
        
    }
    
    /******************************************************/
    /*******************///MARK: NumQuestionAttempts
    /******************************************************/
    
//    func setupQuestionAttemptsAndSet(){
//        setupFetchedResultsController(entityName: "TDPerformanceLog", sortKey: "datetime", frcKey: keyQuestionAttempts)
//        setStats(frcKey: keyQuestionAttempts)
//    }
    
    func executeSearch(frcKey: String) {
        if let fc = frcDict[frcKey] {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(frcDict[frcKey])")
            }
        }
    }
    
    func setupFetchedResultsController(entityName: String, sortKey: String, frcKey: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fr.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: false)]
        
        //only return where isActive is set to true
        //let pred = NSPredicate(format: "isActive = %@", argumentArray: [true])
        
        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fc.delegate = self
        frcDict[frcKey] = fc
        executeSearch(frcKey: frcKey)

        return fc
    }
    
    func setStats(frcKey:String) {
        
        if let occurrences = frcDict[frcKey]?.fetchedObjects {
            
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: occurrences.count)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
            
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no studySessions, setting numStudySessions to zero")
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: 0)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
        }
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
            let newOverviewStatistic = OverviewStatistic(order: orderStudySessions, description: "Mission", number: studySessions.count)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
            
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no studySessions, setting numStudySessions to zero")
            let newOverviewStatistic = OverviewStatistic(order: orderStudySessions, description: "Mission", number: 0)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
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
            
            let newOverviewStatistic = OverviewStatistic(order: orderAppSessions, description: "App Sessions", number: sessions.count)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no sessions, setting numAppSessions to zero")
            let newOverviewStatistic = OverviewStatistic(order: orderAppSessions, description: "App Sessions", number: 0)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
        }
    }
    
    
    /******************************************************/
    /*******************///MARK: Segmented Control
    /******************************************************/
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            showOverviewSegment()
        case 1:
            showGemSegment()
        case 2:
            showGoalsSegment()
        default:
            break;
        }
    }
    
    func showOverviewSegment() {
        self.collectionView = self.statsOverviewCollectionView
        
        UIView.animate(withDuration: 0.1, animations: {
            self.refreshStats()
            
        })
    }
    
    func showGemSegment() {

    }
    
    func showGoalsSegment() {

    }
    
    func refreshStats() {
        setStatsNumAppSessions()
        setStatsNumStudySessions()
        setStats(frcKey: keyQuestionAttempts)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

