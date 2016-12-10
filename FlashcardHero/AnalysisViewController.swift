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
   
    
    let keyStudySessions = "Lifetime Missions"
    let keyStudySessionsToday = "Missions Today"
    let keyAppSessions = "App Sessions"
    let keyQuestionAttemptsToday = "Questions Attempted Today"
    let keyQuestionAttempts = "Lifetime Questions Attempted"
    let keyAccuracy = "Lifetime Accuracy"
    let keyAccuracyToday = "Accuracy Today"
    
    
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
        
        
        orderDict = [keyStudySessions : 5,
        keyAppSessions : 6,
        keyQuestionAttempts : 4,
        keyQuestionAttemptsToday: 1,
        keyAccuracy: 3,
        keyAccuracyToday: 0,
        keyStudySessionsToday: 2]
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let newDate = cal.startOfDay(for: date)
    
        //setup the App Sessions Counter
        _ = setupFetchedResultsController(frcKey: keyAppSessions, entityName: "AppSession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)],  predicate: nil)
        setBasicCountingStat(frcKey: keyAppSessions)
        
        //Study Sessions Counter
        _ = setupFetchedResultsController(frcKey: keyStudySessions, entityName: "StudySession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)],  predicate: nil)
        setBasicCountingStat(frcKey: keyStudySessions)
        
        //Study Sessions Today Counter
        _ = setupFetchedResultsController(frcKey: keyStudySessionsToday, entityName: "StudySession", sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)],  predicate: NSPredicate(format: "start > %@", argumentArray: [newDate]))
        setBasicCountingStat(frcKey: keyStudySessionsToday)
        
        
        //Question Attempts counter
        _ = setupFetchedResultsController(frcKey: keyQuestionAttempts, entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],  predicate: nil)
        setBasicCountingStat(frcKey: keyQuestionAttempts)
        
        //Question Attempts Today counter
        
        _ = setupFetchedResultsController(frcKey: keyQuestionAttemptsToday, entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],  predicate: NSPredicate(format: "datetime > %@", argumentArray: [newDate]))
        setBasicCountingStat(frcKey: keyQuestionAttemptsToday)
        
        //accuracy
        _ = setupFetchedResultsController(frcKey: keyAccuracy, entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],  predicate: nil)
        setAccuracyStat(frcKey: keyAccuracy)
        
        //accuracy Today
        _ = setupFetchedResultsController(frcKey: keyAccuracyToday, entityName: "TDPerformanceLog", sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],  predicate: NSPredicate(format: "datetime > %@", argumentArray: [newDate]))
        setAccuracyStat(frcKey: keyAccuracyToday)
        
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
    /*******************///MARK: Accuracy
    /******************************************************/

    func calculateAccuracyString(frcKey: String) -> String {
        
        var correct: Double = 0.0
        var incorrect: Double = 0.0
        
        //get array of all performance objects
        if let TDPerformanceLogs = frcDict[frcKey]?.fetchedObjects as? [TDPerformanceLog] {
            for log in TDPerformanceLogs {
                if log.wasCorrect {
                    correct += 1
                } else {
                    incorrect += 1
                }
            }
            
            //calculate accuracy
            let accuracy: Double = correct/(correct+incorrect)
            
            if accuracy < 0.0 || accuracy > 1.0 {
                print("Error, accuracy calclated outside of bounds \(accuracy)")
                return "-1"
            } else {
                print("Calculated accuracy: \(accuracy)")
                
                if accuracy.isNaN || accuracy.isInfinite {
                    return "--"
                } else {
                    let aValue = Int(round(accuracy * 100))
                    return "\(aValue)%"
                }
            }
            
        } else {
            print("Couldn't calculate accuracy")
            return "-1"
        }
    }
    

    /******************************************************/
    /*******************///MARK: FetchedResultsControllers and Stats
    /******************************************************/
    
    func setAccuracyStat(frcKey: String) {
        let accuracy = calculateAccuracyString(frcKey: frcKey)
        
        let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: accuracy)
        insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
    }
    
    func setBasicCountingStat(frcKey:String) {
        
        if let occurrences = frcDict[frcKey]?.fetchedObjects {
            
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: String(describing: occurrences.count))
            insertOverviewStatisticIntoStatsOverviewItems(newOverviewStatistic)
            
            
        } else {
            //TODO: Handle no sessions returned
            print("Found no \(frcKey), setting to zero")
            let newOverviewStatistic = OverviewStatistic(order: orderDict[frcKey]!, description: frcKey, number: "0")
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
        setBasicCountingStat(frcKey: keyAppSessions)
        setBasicCountingStat(frcKey: keyStudySessions)
        setBasicCountingStat(frcKey: keyQuestionAttempts)
        setBasicCountingStat(frcKey: keyQuestionAttemptsToday)
        setBasicCountingStat(frcKey: keyStudySessionsToday)
        setAccuracyStat(frcKey: keyAccuracy)
        setAccuracyStat(frcKey: keyAccuracyToday)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

