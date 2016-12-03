//
//  GameTrueFalseViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/7/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameTrueFalseViewController: CoreDataTrueFalseGameController, GameObjectiveMaxPoints {

    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    @IBOutlet weak var termText: UILabel!
    @IBOutlet weak var definitionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quizletAttributionImage: UIImageView!

    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    var points = 0
    
    var showingCorrectAnswer: Bool = false
    var correctTD: QuizletTermDefinition?
    var wrongTD: QuizletTermDefinition?
    
    var objective: String?
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupFetchedResultsController()
        //setupPerformanceLogFetchedResultsController()
        
        setupInitialPlayspace()
        //TODO: Check for case where no set contains more than 1 term.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataChecks()
        
        
        setupNewQuestion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    /******************************************************/
    /*******************///MARK: User Alerts
    /******************************************************/

    func alertUserNoGems() {
        let title = "No Gems Available"
        let message = "The game cannot find any Gems to load.  Either you do not have any Gems activated (the switch on the Gems screen) or you have not downloaded any Sets from Quizlet.  Go to your Gems page and then try playing again!"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Quit",
                                          style: UIAlertActionStyle.default,
                                          handler: {(action:UIAlertAction) in self.quit()})
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: Data Checks Validations
    /******************************************************/

    func dataChecks() {
        checkForCompatableGems()
    }
    
    /**
     Checks the gems in the query to see if they are suitable for this game
     */
    func checkForCompatableGems() {
        //fetch sets
        if let fc = frcDict[keySets] {
            print((fc.fetchedObjects?.count)!)
            
            guard (fc.fetchedObjects?.count)! > 0 else {
                alertUserNoGems()
                return
            }
        }
    }
    
    /******************************************************/
    /*******************///MARK: Misc
    /******************************************************/

    func setupInitialPlayspace() {
        setFeedbackVisible(visible: false)
        setAnswerButtonsVisible(visible: false)
        self.definitionText.alpha = 0
        self.termText.alpha = 0
        self.imageView.alpha = 0
        self.quizletAttributionImage.alpha = 0
        self.points = 0
        
        //setup button corners
        trueButton.layer.masksToBounds = true
        trueButton.layer.cornerRadius = CGFloat(4.0)
        
        falseButton.layer.masksToBounds = true
        falseButton.layer.cornerRadius = CGFloat(4.0)
        
        quitButton.layer.masksToBounds = true
        quitButton.layer.cornerRadius = CGFloat(4.0)
        
        refreshPoints()
    }
    
    /******************************************************/
    /*******************///MARK: Objectives
    /******************************************************/

    func didPlayerCompleteMission() -> Bool {
        switch self.objective {
        case ("MaxPoints")?:
            return didPlayerReachMaxPoints()
        default:
            return false
        }
    }
    
    func didPlayerFailMission() -> Bool {
        switch self.objective {
        case ("MaxPoints")?:
            return didPlayerReachMinPoints()
        default:
            return false
        }
    }
    
    /******************************************************/
    /*******************///MARK: GameObjectiveBase
    /******************************************************/
    var gameCallerDelegate: GameCaller? = nil
    
    func finishGame(_ didPlayerSucceed: Bool) {
        if let gameDelegate = self.gameCallerDelegate {
            self.dismiss(animated: true, completion: {gameDelegate.gameFinished(didPlayerSucceed, forGame: GameDirectory.gameTrueFalse)})
        } else {
            //TODO: Handle problem
        }
        
    }
    
    /******************************************************/
    /*******************///MARK: GameObjectiveMaxPoints
    /******************************************************/


    var objectiveMaxPoints: Int = 0
    var objectiveMinPoints: Int = -1
    
    //allow this game to be played until a max score is reached
    func playGameUntil(playerScoreIs maxPoints: Int, unlessPlayerScoreReaches minPoints: Int? = -10, sender: GameCaller) {
        print("playGameUntil was called")
        self.objective = "MaxPoints"
        self.gameCallerDelegate = sender
        
        //points needed to meet the objective
        self.objectiveMaxPoints = maxPoints
        
        //score where objective will fail
        if let minPoints = minPoints {
            self.objectiveMinPoints = minPoints
        } else {
            self.objectiveMinPoints = -1
        }
    }
    
    func didPlayerReachMaxPoints() -> Bool{
        if self.points >= self.objectiveMaxPoints {
            return true
        } else {
            return false
        }
    }
    
    func didPlayerReachMinPoints() -> Bool{
        if self.points <= self.objectiveMinPoints {
            return true
        } else {
            return false
        }
    }
    
    /******************************************************/
    /*******************///MARK: Game Functions
    /******************************************************/

    func addRefreshPoints(_ newPoints: Int) {
        awardPoints(newPoints)
        refreshPoints()
        
        //check to see if the player met objectives or failed
        if didPlayerCompleteMission() {
            finishGame(true)
        } else if didPlayerFailMission() {
            finishGame(false)
        }
    }
    
    func awardPoints(_ newPoints: Int) {
        self.points += newPoints
    }
    
    func getRandomSet(sets: [QuizletSet]) -> QuizletSet {
        let numberOfSets = sets.count
        
        //get random number between 0 and count-1
        let randSetIndex = Int(arc4random_uniform(UInt32(numberOfSets)))
        
        //get a random set
        let quizletSet = sets[randSetIndex] 
        
        return quizletSet
    }
    
    func getRandomSetWithMultipleTerms(sets: [QuizletSet]) -> QuizletSet {
        
        //make sure this set has more than 1 term before continuting
        var numberOfTerms = 0
        var quizletSet: QuizletSet
        var tfc: NSFetchedResultsController<NSFetchRequestResult>
        repeat {
            quizletSet = getRandomSet(sets: sets)
            //fetch terms from the given set
            setupTermFRC(set: quizletSet)
            
            if let tempTfc = frcDict[keyTerms] {
                
                tfc = tempTfc
                
                if let terms = tfc.fetchedObjects {
                    
                    numberOfTerms = terms.count
                } else {
                    //TODO: handle nil tfc.fetchedObjects
                }
            } else {
                //TODO: handle nil termFetchedResultsController
            }
        } while numberOfTerms <= 1
        
        return quizletSet
    }
    
    func randTrueFalse() -> Bool {
        let flip = Int(arc4random_uniform(UInt32(2)))
        if flip == 1 {
            return true
        } else if flip == 0 {
            return false
        } else {
            //unexpected flip
            return false
        }
    }
    
    func setupNewQuestion() {
        self.definitionText.text = ""
        self.termText.text = ""
        
        //fetch sets
        if let fc = frcDict[keySets] {
            //print((fc.fetchedObjects?.count)!)
            
            guard (fc.fetchedObjects?.count)! > 0 else {
                //TODO: handle zero sets returned with message to user
                return
            }
  
            
            //get an array of sets
            if let sets = fc.fetchedObjects as? [QuizletSet] {
                
                //get a quizlet set that has more than 1 term
                let quizletSet = getRandomSetWithMultipleTerms(sets: sets)

                //now get a random question from the set
                //fetch terms from the given set
                setupTermFRC(set: quizletSet)
                
                if let tfc = frcDict[keyTerms] {
                    
                    guard (tfc.fetchedObjects?.count)! > 0 else {
                        //TODO: handle zero terms returned with alert to user
                        return
                    }
                    
                     if let terms = tfc.fetchedObjects as? [QuizletTermDefinition] {
                        
                        let numberOfTerms = terms.count
                        
                        //get random number between 0 and count-1
                        let randTermIndex = Int(arc4random_uniform(UInt32(numberOfTerms)))
                        
                        let quizletTermDefinition = terms[randTermIndex]
                        
                        let question = quizletTermDefinition.term
                        let correctAnswer = quizletTermDefinition.definition
                        let correctImage = quizletTermDefinition.imageData
                        correctTD = quizletTermDefinition
                        
                        //get a random definition as a wrong answer that isn't the same as the correct answer
                        var randDefinitionIndex: Int
                        repeat {
                            randDefinitionIndex = Int(arc4random_uniform(UInt32(numberOfTerms)))
                        } while randDefinitionIndex == randTermIndex
                        
                        
                        let wrongQuizletTermDefinition = terms[randDefinitionIndex]
                        
                        let wrongAnswer = wrongQuizletTermDefinition.definition
                        let wrongImage = wrongQuizletTermDefinition.imageData
                        
                        //set the question
                        self.termText.text = question
                        
                        //determine if will show correct answer
                        
                        let willShowCorrect = randTrueFalse()
                        self.showingCorrectAnswer = willShowCorrect
                        
                        if willShowCorrect {
                            self.definitionText.text = correctAnswer
                            wrongTD = nil
                            if let imageData = correctImage {
                                self.imageView?.image = UIImage(data:imageData as Data,scale:1.0)
                            }
                        } else {
                            self.definitionText.text = wrongAnswer
                            if let imageData = wrongImage {
                                self.imageView?.image = UIImage(data:imageData as Data,scale:1.0)
                            }
                            wrongTD = wrongQuizletTermDefinition
                        }
                        self.setQuestionVisible(visible: true);
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: { self.setAnswerButtonsVisible(visible: true)})
                     } else {
                        //TODO: tfc.fetchedObjects nil or not array of quizletTermDefinitions
                    }
                    
                } else {
                    //TODO: Handle termFetchedResultsController nil
                }
                
            } else {
                //TODO: handle fetchedResultsController nil
            }
        }
    }
    
    func answerQuestion(answer: Bool) {
        //check the correct answer
        setAnswerButtonsVisible(visible: false)
        setQuestionVisible(visible: false)
        
        let datetime = NSDate()
        var wasCorrect: Bool
        
        let conditions = (answer, showingCorrectAnswer)
        
        switch conditions {
        //player answered true, the answer showing is the correct answer
        case (true, true):
            //they answered correctly
            wasCorrect = true
            setFeedbackMessage(wasCorrect: true)
            addRefreshPoints(1)
        //player answered false, the answer showing is also false
        case (false, false):
            //they answered correctly
            wasCorrect = true
            setFeedbackMessage(wasCorrect: true)
            addRefreshPoints(1)
        
        //any other situation
        default:
            //answered incorrectly
            wasCorrect = false
            setFeedbackMessage(wasCorrect: false)
            addRefreshPoints(-1)
            
        }
        setFeedbackVisible(visible: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {self.dismissFeedback()})
        
        //log the activity
        
        let newLog = TDPerformanceLog(datetime: datetime,
                                      questionTypeId: 0,
                                      wasCorrect: wasCorrect,
                                      quizletTD: self.correctTD!,
                                      wrongAnswerTD: self.wrongTD,
                                      wrongAnswerFITB: nil,
                                      studySession: self.studySession!,
                                      context: self.frcDict[keyPerformanceLog]!.managedObjectContext)
    }
    
    /******************************************************/
    /*******************///MARK: Feedback and Display
    /******************************************************/

    func refreshPoints() {
        pointsLabel.text = String(points)
    }
    
    func setFeedbackMessage(wasCorrect: Bool){
        if wasCorrect {
            self.feedbackLabel.text = "Correct!"
            //set color to green
            self.feedbackLabel.backgroundColor = UIColor.green
        } else {
            self.feedbackLabel.text = "Wrong!"
            //set color to red
            self.feedbackLabel.backgroundColor = UIColor.red
        }
    }
    func setFeedbackVisible(visible: Bool) {
  
        if visible {
            UIView.animate(withDuration: 0.1, animations: {
                self.feedbackLabel.alpha = 1.0
            })
        } else {
            //self.feedbackLabel.text = ""
            UIView.animate(withDuration: 0.2, animations: {
                self.feedbackLabel.alpha = 0.0
            })
        }
    }
    
    func setAnswerButtonsVisible(visible: Bool) {
        if visible {
            UIView.animate(withDuration: 0.4, animations: {
                self.trueButton.alpha = 1.0
                self.falseButton.alpha = 1.0
            })
        } else {
            //self.feedbackLabel.text = ""
            UIView.animate(withDuration: 0.1, animations: {
                self.trueButton.alpha = 0.0
                self.falseButton.alpha = 0.0
            })
        }
    }
    
    func setQuestionVisible(visible: Bool) {
        if visible {
            UIView.animate(withDuration: 0.3, animations: {
                self.termText.alpha = 1
                self.definitionText.alpha = 1
                self.imageView.alpha = 1
                self.quizletAttributionImage.alpha = 1
            })
        } else {
            //self.feedbackLabel.text = ""
            UIView.animate(withDuration: 0.1, animations: {
                self.termText.alpha = 0
                self.definitionText.alpha = 0
                self.imageView.alpha = 0
                self.quizletAttributionImage.alpha = 0
            })
        }
    }
    
    func dismissFeedback() {
        setFeedbackVisible(visible: false)
        setupNewQuestion()
        
    }
    
    /******************************************************/
    /*******************///MARK: Button Actions
    /******************************************************/

    @IBAction func quitButtonPressed(_ sender: Any) {
        quit()
    }
    
    @IBAction func trueButtonPressed(_ sender: Any) {
        answerQuestion(answer: true)
    }
    
    @IBAction func falseButtonPressed(_ sender: Any) {
        answerQuestion(answer: false)
    }
    
    func quit() {
        finishGame(false)
    }

    
    

    /******************************************************/
    /******************* Model Operations **************/
    /******************************************************/
    //MARK: - Model Operations

    
    func fetchModelQuizletSets() -> [QuizletSet] {
        return frcDict[keySets]!.fetchedObjects as! [QuizletSet]
    }
    
    func fetchQuizletTermDefinitions(set: QuizletSet) -> [QuizletTermDefinition] {
        
        setupTermFRC(set: set)
        
        return frcDict[keyTerms]!.fetchedObjects as! [QuizletTermDefinition]
    }
}
