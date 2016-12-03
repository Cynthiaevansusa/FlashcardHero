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
        
        
        _ = setupFetchedResultsController(frcKey: keyGameLevel, entityName: "GameLevel", sortDescriptors: [NSSortDescriptor(key: "level", ascending: false)],  predicate: nil)
        
        
        
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
            
            let vc = storyboard?.instantiateViewController(withIdentifier: game.storyboardId)
            
            if let trueFalseVc = vc as? GameTrueFalseViewController { //if it is a true false game
                
                //set the level
                let objective = getGameObjective(game: game)
                
                present(trueFalseVc, animated: true, completion: {trueFalseVc.playGameUntil(playerScoreIs: objective.maxPoints, unlessPlayerScoreReaches: objective.minPoints, sender: self)})
            }
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

    func gameFinished(_ wasObjectiveAchieved: Bool, forGame sender: Game) {
        print("Game finished.  Player success? \(wasObjectiveAchieved)")
        
        //if they succeeded award reward and increase level. If they lost, decrease by 2
        
        if wasObjectiveAchieved {
            //increase level
            increaseGameLevel(of: sender)
            
        } else {
            decreaseGameLevel(of: sender)
        }
        
        collectionView.reloadData()
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
        
        //set the level
        let level = getGameLevel(game: game)
        let objective = getGameObjective(game: game)
        cell.level.text = String(describing: level)
        cell.objective.text = objective.description
        cell.reward.text = "\(objective.reward) Essence"
        
        return cell
    }
   
    /******************************************************/
    /*******************///MARK: Game level and objectives
    /******************************************************/

    func increaseGameLevel(of game: Game) {
        if let fc = frcDict[keyGameLevel] {
            
            if (fc.sections?.count)! > 0, let gameLevels = fc.fetchedObjects as? [GameLevel]{
                for gameLevel in gameLevels {
                    if gameLevel.gameId == Int64(game.id) {
                        //update this record to the next game level and return
                        gameLevel.level += 1
                        return
                    }
                }
                
                //if didn't find at end of loop, must not be an entry, so create one at level 1
                _ = GameLevel(gameId: game.id, level: 1, context: fc.managedObjectContext)
                return
            } else {
                return
            }
        } else {
            return
        }
    }
    
    func decreaseGameLevel(of game: Game) {
        if let fc = frcDict[keyGameLevel] {
            
            if (fc.sections?.count)! > 0, let gameLevels = fc.fetchedObjects as? [GameLevel]{
                for gameLevel in gameLevels {
                    if gameLevel.gameId == Int64(game.id) {
                        //update this record to the next game level and return
                        gameLevel.level -= 2
                        //don't let level go below 0
                        if gameLevel.level < 0 {
                            gameLevel.level = 0
                        }
                        return
                    }
                }
                //if didn't find at end of loop, must not be an entry, so create one at level 0
                _ = GameLevel(gameId: game.id, level: 0, context: fc.managedObjectContext)
                return
            } else {
                return
            }
        } else {
            return
        }
    }
    
    /** 
     check records to see if this game has an indicated level and return it or 0
     */
    func getGameLevel(game: Game) -> Int {
        if let fc = frcDict[keyGameLevel] {
        
            if (fc.sections?.count)! > 0, let gameLevels = fc.fetchedObjects as? [GameLevel]{
                for gameLevel in gameLevels {
                    if gameLevel.gameId == Int64(game.id) {
                        return Int(gameLevel.level)
                    }
                }
                
                //if didn't find at end of loop, must not be an entry, so level 0
                return 0
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    /**
     Based on the level of the game, develop some objectives and return
     */
    func getGameObjective(game: Game) -> GameObjectiveRewardStructMaxPoints {
        
        //TODO: Impliment fibonnaci method
        
        let gameLevel = getGameLevel(game: game)
        
        let maxPoints = gameLevel + 5
        let minPoints = -5
        let description = "Achieve a score of \(maxPoints) points."
        let reward = gameLevel + 1
        
        let objective = GameObjectiveRewardStructMaxPoints(maxPoints: maxPoints, minPoints: minPoints, description: description, reward: reward)
        return objective
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

struct GameObjectiveRewardStructMaxPoints {
    var maxPoints: Int
    var minPoints: Int
    var description: String
    var reward: Int
}
