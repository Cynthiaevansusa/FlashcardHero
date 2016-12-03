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

class CommandCenterViewController: CoreDataQuizletCollectionViewController, UICollectionViewDataSource, GameCaller {


    @IBOutlet weak var missionsCollectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var keyGameLevel = "GameLevel"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //link the collection view to the coredata class
        self.collectionView = self.missionsCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        _ = setupFetchedResultsController(frcKey: keyGameLevel, entityName: "GameLevel", sortDescriptors: [NSSortDescriptor(key: "gameId", ascending: true)],  predicate: nil)
        
        //set up the FRCs
        
        // Do any additional setup after loading the view, typically from a nib.
        showMissionsSegment()

    }

    
    //adapted from http://stackoverflow.com/questions/28347878/ios8-swift-buttons-inside-uicollectionview-cell
    @IBAction func startMissionButtonPressed(_ sender: UIButton) {
        let touchPoint = collectionView.convert(CGPoint.zero, from: sender)
        if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
            // now you know indexPath. You can get data or cell from here.
            let game = GameDirectory.activeGames[indexPath.row]
            
            let gameId = game.name
            
            print("You pushed button for game \(gameId)")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: game.storyboardId) as! GameTrueFalseViewController
            
            present(vc, animated: true, completion: {vc.playGameUntil(playerScoreIs: 5, unlessPlayerScoreReaches: -5, sender: self)})
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
            showGoalsSegment()
        default:
            break; 
        }
    }
    
    func showMissionsSegment() {
        print("Showing the missions segment")
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsCollectionView.alpha = 1.0
            self.missionsCollectionView.isHidden = false

        })
    }
    
    func showGoalsSegment() {
        UIView.animate(withDuration: 0.1, animations: {
            self.missionsCollectionView.alpha = 0.0
            self.missionsCollectionView.isHidden = true
 
        })
    }
    
    /******************************************************/
    /*******************///MARK: GameCaller
    /******************************************************/

    func gameFinished(_ wasObjectiveAchieved: Bool) {
        print("Game finished.  Player success? \(wasObjectiveAchieved)")
    }
    
    
    /******************************************************/
    /*******************///MARK: UICollectionViewDataSource
    /******************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("The are \(GameDirectory.activeGames.count) active games that will be displayed")
        return GameDirectory.activeGames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MissionCell", for: indexPath as IndexPath) as! CustomMissionCollectionViewCell
        
        let game = GameDirectory.activeGames[indexPath.row]
        print("Showing mission for game: \(game.name)")
        
        //associate the photo with this cell, which will set all parts of image view
        cell.game = game
        
        return cell
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

