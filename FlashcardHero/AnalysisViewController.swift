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
   
    
    let keyStudySessions = "Missions"
    let keyAppSessions = "App Sessions"
    let keyQuestionAttempts = "Question Attempts"
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var statsOverviewItems: [String:OverviewStatistic] = [:]
    var statsOverviewCollectionData: [OverviewStatistic] = []
    
    var orderDict: [String:Int] = [:]
    
    let orderAppSessions = 0
    let orderStudySessions = 1
    let orderQuestionAttempts = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView = statsOverviewCollectionView
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        orderDict = [keyStudySessions : 1,
        keyAppSessions : 0,
        keyQuestionAttempts : 2]
    
        //setup the App Sessions Counter
        _ = setupFetchedResultsController(frcKey: keyAppSessions, entityName: "AppSession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)],  predicate: nil)
        setStats(frcKey: keyQuestionAttempts)
        
        //Study Sessions Counter
        _ = setupFetchedResultsController(frcKey: keyStudySessions, entityName: "StudySession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)],  predicate: nil)
        setStats(frcKey: keyQuestionAttempts)
        //Question Attempts counter
        _ = setupFetchedResultsController(frcKey: keyQuestionAttempts, entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],  predicate: nil)
        setStats(frcKey: keyQuestionAttempts)
        
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
    /*******************///MARK: FetchedResultsControllers and Stats
    /******************************************************/
    
    
    
    
    func setStats(frcKey:String) {
        
        if let occurrences = frcDict[frcKey]?.fetchedObjects {
            
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: occurrences.count)
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
            
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no \(frcKey), setting to zero")
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: 0)
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
        setStats(frcKey: keyAppSessions)
        setStats(frcKey: keyStudySessions)
        setStats(frcKey: keyQuestionAttempts)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

