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
            let gameVariant = GameDirectory.activeGameVariants[indexPath.row]
            let game = gameVariant.game
            let gameId = game.name
            
            print("You pushed button for game \(gameId)")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: game.storyboardId)
            
            if let trueFalseVc = vc as? GameTrueFalseViewController { //if it is a true false game
                
                //set the level
                //let objective =
                
                //check for the variant
                if let objective = getGameObjective(gameVariant: gameVariant) as? GameObjectiveMaxPoints {
                        present(trueFalseVc, animated: true, completion: {trueFalseVc.playGameUntil(playerScoreIs: objective.maxPoints, unlessPlayerScoreReaches: objective.minPoints, sender: self)})
                } else if let objective = getGameObjective(gameVariant: gameVariant) as? GameObjectivePerfectScore {
                        present(trueFalseVc, animated: true, completion: {trueFalseVc.playGameUntil(playerReaches: objective.maxPoints, unlessPlayerMisses: objective.missedPoints, sender: self)})
                }
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
        
        return GameDirectory.activeGameVariants.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MissionCell", for: indexPath as IndexPath) as! CustomMissionCollectionViewCell
        
        let gameVariant = GameDirectory.activeGameVariants[indexPath.row]
        let game = gameVariant.game
        print("Showing mission for game: \(game.name)")
        
        //associate the photo with this cell, which will set all parts of image view
        cell.gameVariant = gameVariant
        
        //set the level
        let level = getGameLevel(game: game)
        let objective = getGameObjective(gameVariant: gameVariant)
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
    
    //TODO: make following function return something that conforms with GameObjective protocol
    
    func getGameObjective(gameVariant: GameVariant) -> GameObjective {
        //check for the variant
            
        switch gameVariant.gameProtocol {
        case GameVariantProtocols.MaxPoints:
            return getGameObjectiveMaxPoints(game: gameVariant.game)
        case GameVariantProtocols.PerfectGame:
            return getGameObjectivePerfectScore(game: gameVariant.game)
        default:
            fatalError("Asked for a game variant that doesn't exist")
        }
    
    }
    
    /**
     Based on the level of the game, develop some objectives and return
     */
    func getGameObjectiveMaxPoints(game: Game) -> GameObjectiveMaxPoints {
        
        //TODO: Impliment fibonnaci method
        
        let gameLevel = getGameLevel(game: game)
        
        let maxPoints = gameLevel + 5
        let minPoints = -5
        let description = "Achieve a score of \(maxPoints) points!"
        let reward = gameLevel + 1
        
        let objective = GameObjectiveMaxPoints()
        objective.maxPoints = maxPoints
        objective.minPoints = minPoints
        objective.description = description
        objective.reward = reward
        
        return objective
    }
    
    func getGameObjectivePerfectScore(game: Game) -> GameObjectivePerfectScore {
        
        //TODO: Impliment fibonnaci method
        
        let gameLevel = getGameLevel(game: game)
        
        let maxPoints = gameLevel + 5
        var missedPointsAllowed = 15 - gameLevel
        if missedPointsAllowed < 1 { missedPointsAllowed = 1 } //make sure missed points is greater than 1
        let description = "Achieve a score of \(maxPoints) points... but don't get \(missedPointsAllowed) wrong!"
        let reward = gameLevel + 2
        
        let objective = GameObjectivePerfectScore()
        objective.maxPoints = maxPoints
        objective.missedPoints = missedPointsAllowed
        objective.description = description
        objective.reward = reward
        
        return objective
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

protocol GameObjectiveProtocol: class {
    var maxPoints: Int {get set}
    var description: String {get set}
    var reward: Int {get set}
}

class GameObjective: GameObjectiveProtocol {
    var maxPoints: Int = 0
    var description: String = ""
    var reward: Int = 0
}

class GameObjectiveMaxPoints: GameObjective {
    //var maxPoints: Int = 0
    var minPoints: Int = -1
    //var description: String = ""
    //var reward: Int = 0
}

class GameObjectivePerfectScore: GameObjective {
    //var maxPoints: Int = 0
    var missedPoints: Int = -1
    //var description: String = ""
    //var reward: Int = 0
}
