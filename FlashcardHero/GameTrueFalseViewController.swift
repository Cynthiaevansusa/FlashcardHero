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

class GameTrueFalseViewController: CoreDataTrueFalseGameController, GameVariantMaxPoints, GameVariantPerfectGame {

    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    @IBOutlet weak var termText: UILabel!
    @IBOutlet weak var definitionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quizletAttributionImage: UIImageView!

    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    let missionFeedbackSegueIdentifier = "segueShowMissionFeedback"
    
    //general game variables
    var points = 0
    var lives = 1
    var questionsWrong = 0
    var questionsCorrect = 0
    var didPlayerSucceed = false
    
    //timer variables
    let startDateTime = {return Date() }() //to calculate duration and timer
    var dateTimeNow: Date { //to calculate timer and final duration
        get {
            return Date()
        }
    }

    var elapsedDateInterval: DateInterval {
        get {
            return DateInterval(start: startDateTime, end: dateTimeNow)}
    }
    var timer = Timer()
    
    //FC keys
    let keyAccurracy = "Accurracy"
    
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
        
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        //setup accurracy FRC
        //create FRC for sets using the studySession created in the superclass
        _ = setupFetchedResultsController(frcKey: keyAccurracy, entityName: "TDPerformanceLog",
                                          sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
                                          predicate: NSPredicate(format: "studySession = %@", argumentArray: [self.studySession!]))
        
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

    /**
     Alert the user that there are no valid Sets (Gems) avilable to play with.  This shouldn't have to be called if the CommandCenter properly checks before the user wants to launch and disables the user's ability to launch the game.
     */
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
    
    /**
     Alert the user of their request to quit, and find out if they want to quit.  Allow them to quit if the pick the appropriate response, dismiss otherwise.
     */
    func alertQuit() {
        let title = "Quit?"
        let message = "This will count as a Mission Failure!"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let quitAction = UIAlertAction(title: "Yes",
                                          style: UIAlertActionStyle.default,
                                          handler: {(action:UIAlertAction) in self.quit()})
        
        let stayAction = UIAlertAction(title: "No",
                                       style: UIAlertActionStyle.default,
                                       handler: nil)
        
        alert.addAction(quitAction)
        alert.addAction(stayAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /******************************************************/
    /*******************///MARK: Data Checks Validations
    /******************************************************/

    /**
     Any data checks that need to be run before the game will start should be put in this function.
     */
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
    /*******************///MARK: Timers and Clocks
    /******************************************************/

    func updateTimer() {
        let timeString = elapsedDateInterval.timeIntervalAsString(format: "MM:ss")
        
        timerLabel.text = timeString
        
        //print("Updated timer to \(timeString)")
    }
    
    /******************************************************/
    /*******************///MARK: Misc
    /******************************************************/

    /**
     Does an initial setup of the playspace UI
     */
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
        
        definitionText.layer.masksToBounds = true
        definitionText.layer.cornerRadius = 5
        
        refreshPoints()
        refreshLives()
    }
    
    /******************************************************/
    /*******************///MARK: Finishing Mision, determining score
    /******************************************************/
    
    
    /**
     Called when the game is over, sends player to the mission summary.  This function will end the game and call any closures.  The points delivered to this function should be the actual points, etc to be awarded to the player.
     */
    func displayMissionFinishSummary(_ wasSuccess: Bool) {
        self.didPlayerSucceed = wasSuccess
        
        self.performSegue(withIdentifier: missionFeedbackSegueIdentifier, sender: self)
        
    }
    
    func calculateDidPlayerSucceed() -> Bool {
        return didPlayerSucceed
    }
    
    func calculateNumStars() -> Int {
        //check stars and smooth input if needed
        var starsOutput = 3
        
        if didPlayerSucceed {
            starsOutput = 3
        } else {
            starsOutput = 0
        }
        
        if starsOutput > 3 || starsOutput < 0 {
            starsOutput = 0
        }
        
        return starsOutput
    }
    
    func calculateTimeElapsedString() -> String {
        //time elapsed
        let timeElapsedString = elapsedDateInterval.timeIntervalAsString(format: "MM:ss")
        return timeElapsedString
    }
    
    func calculateTotalPoints() -> Int {
        return points
    }
    
    /**
     Returns a double between 0.0 and 1.0 (inclusive) describing the accurracy of correct vs incorrect answers during the active study session.  Returns -1.0 if detected error.
     */
    func calculateAccurracy() -> Double {
        
        var correct: Double = 0.0
        var incorrect: Double = 0.0
        
        //get array of all performance objects
        if let TDPerformanceLogs = frcDict[keyAccurracy]?.fetchedObjects as? [TDPerformanceLog] {
            for log in TDPerformanceLogs {
                if log.wasCorrect {
                    correct += 1
                } else {
                    incorrect += 1
                }
            }
            
            //calculate accurracy
            let accurracy: Double = correct/(correct+incorrect)
            
            if accurracy < 0.0 || accurracy > 1.0 {
                print("Error, accurracy calclated outside of bounds \(accurracy)")
                return -1.0
            } else {
                print("Calculated accurracy: \(accurracy)")
                return accurracy
            }
            
        } else {
            print("Couldn't calculate accurracy")
            return -1.0
        }
    }
    
    func calculateCustomStats() -> [String:Any] {
        var customStats = [String:Any]()
        
        return customStats
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == missionFeedbackSegueIdentifier {
            if let destination = segue.destination as? MissionFeedbackViewController {
                
                destination.setupWith(wasSuccess: calculateDidPlayerSucceed(),
                               numStars: calculateNumStars(),
                               timeElapsedString: calculateTimeElapsedString(),
                               totalPoints: calculateTotalPoints(),
                               accurracy: calculateAccurracy(),
                               customStats: calculateCustomStats(),
                               senderVC: self,
                               destinationVC: nil,
                               vCCompletion: {self.finishGame(self.calculateDidPlayerSucceed())})
                
            }
        }
    }
    
    
    /******************************************************/
    /*******************///MARK: Objectives
    /******************************************************/

    /**
     Checks each game variant protocol to see if the game has been won.  All GameVariantProtocols should register a "win" criteria function here.
     */
    func didPlayerCompleteMission() -> Bool {
        switch self.objective {
        case (GameVariantProtocols.MaxPoints)?:
            return didPlayerReachMaxPoints()
        case (GameVariantProtocols.PerfectGame)?:
            return didPlayerReachMaxPoints()
        default:
            return false
        }
    }
    
    /**
     Checks each game variant protocol to see if the game has been lost.  All GameVariantProtocols should register a "loss" criteria function here.
     */
    func didPlayerFailMission() -> Bool {
        switch self.objective {
        case (GameVariantProtocols.MaxPoints)?:
            return didPlayerReachMinPoints()
        case (GameVariantProtocols.PerfectGame)?:
            return didPlayerReachQuestionsCanMiss()
        default:
            return false
        }
    }
    
    /******************************************************/
    /*******************///MARK: GameObjectiveBase
    /******************************************************/
    var gameCallerDelegate: GameCaller? = nil
    
    /**
     Required by GameObjectiveBase delegate, this is the actual function that ends the game and tells the CommandCenterViewController if the game was won or lost.
     */
    func finishGame(_ didPlayerSucceed: Bool) {

        if let gameDelegate = self.gameCallerDelegate {
            self.dismiss(animated: true, completion: {gameDelegate.gameFinished(didPlayerSucceed, forGame: GameDirectory.GameTrueFalse)})
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
        self.objective = GameVariantProtocols.MaxPoints
        self.gameCallerDelegate = sender
        
        //points needed to meet the objective
        self.objectiveMaxPoints = maxPoints
        
        //score where objective will fail
        if let minPoints = minPoints {
            self.objectiveMinPoints = minPoints
        } else {
            self.objectiveMinPoints = -1
        }
        
        refreshLives()
    }
    
    /**
     Detects if player has reached objectiveMaxPoints
     */
    func didPlayerReachMaxPoints() -> Bool{
        if self.points >= self.objectiveMaxPoints {
            return true
        } else {
            return false
        }
    }
    
    /**
     Detects if player has reached objectiveMinPoints
     */
    func didPlayerReachMinPoints() -> Bool{
        if self.points <= self.objectiveMinPoints {
            return true
        } else {
            return false
        }
    }
    
    /******************************************************/
    /*******************///MARK: GameObjectivePerfectGame
    /******************************************************/
    
    var objectiveQuestionsCanMiss: Int = 1
    var objectiveQuestionsMissed: Int = 0
    
    //allow this game to be played until a max score is reached, but player fails if they miss a certain amount of questions
    func playGameUntil(playerReaches maxPoints: Int, unlessPlayerMisses missedPoints: Int, sender: GameCaller){
        print("playGameUntil was called")
        self.objective = GameVariantProtocols.PerfectGame
        self.gameCallerDelegate = sender
        
        //points needed to meet the objective
        self.objectiveMaxPoints = maxPoints
        
        //missedPoints must be greater than 0 or else the player has already lost!
        guard missedPoints > 0 else {
            return
        }
        
        //points player cannot miss
        self.objectiveQuestionsCanMiss = missedPoints
        
        //setup lives
        lives = missedPoints
        refreshLives()

        //lowest score allowed is the number of missed points
        self.objectiveMinPoints = -1 * missedPoints
        
        //reset number of questions missed so far
        self.objectiveQuestionsMissed = 0
    }
    
    
    /**
     Checks to see if the player reached the objectiveQuestionsCanMiss
     */
    func didPlayerReachQuestionsCanMiss() -> Bool {
        if self.objectiveQuestionsMissed >=  self.objectiveQuestionsCanMiss {
            return true
        } else {
            return false
        }
    }
    

 
    
    /******************************************************/
    /*******************///MARK: General Game Functions
    /******************************************************/

    /**
     Awards the given amount of points and refreshes the UI.  Calls the playerGotQuestionWrong or playerGotQuestionCorrect function based on positive or negative integer input.
     */
    func addRefreshPoints(_ newPoints: Int) {
        //if points are less than 1, then the player missed the question
        if newPoints < 1 {
            playerGotQuestionWrong()
        } else {
            playerGotQuestionCorrect()
        }
        
        awardPoints(newPoints)
        //UI refresh
        refreshPoints()
        refreshLives()

    }
    
    /**
     Gives or removes the given number of points
     */
    func awardPoints(_ newPoints: Int) {
        self.points += newPoints
    }
    
    /**
     Gives or removes the given number of lives
     */
    func awardLives(_ newLives: Int) {
        self.lives += newLives
    }
    
    /**
     Tells the game a palyer got a question wrong, and performs appropriate actions (lives, objectiveQuestionsMissed, questionsWrong)
     */
    func playerGotQuestionWrong() {
        self.objectiveQuestionsMissed += 1
        
        if self.objective == GameVariantProtocols.PerfectGame {
            awardLives(-1)
        }
        questionsWrong += 1
    }
    
    /**
     Tells the game a palyer got a question correct, and performs appropriate actions (questionsCorrect)
     */
    func playerGotQuestionCorrect() {
        questionsCorrect += 1
    }
    
    /**
     Returns a random set from the array of sets input.
     */
    func getRandomSet(sets: [QuizletSet]) -> QuizletSet {
        let numberOfSets = sets.count
        
        //get random number between 0 and count-1
        let randSetIndex = Int(arc4random_uniform(UInt32(numberOfSets)))
        
        //get a random set
        let quizletSet = sets[randSetIndex] 
        
        return quizletSet
    }
    
    /**
     From the given array of sets, returns a random set that contains more than 1 term.
     */
    func getRandomSetWithMultipleTerms(sets: [QuizletSet]) -> QuizletSet {
        
        //make sure this set has more than 1 term before continuting
        var numberOfTerms = 0
        var quizletSet: QuizletSet
        var tfc: NSFetchedResultsController<NSFetchRequestResult>
        
        let onlyLoopThisManyTimes = 3 * sets.count //only loop through 3x the number of total sets to prevent infinate loop
        var haveLoopedThisManyTimes = 0 //keep track of times looped
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
            haveLoopedThisManyTimes += 1
        } while numberOfTerms <= 1 && haveLoopedThisManyTimes <= onlyLoopThisManyTimes
        
        return quizletSet
    }
    
    /**
     Returns true or false with even odds
     */
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
    
    
    /**
     Prepares the UI and presents a new question to the player
     */
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
                                self.imageView.image = UIImage(data:imageData as Data,scale:1.0)
                            } else if self.imageView != nil {
                                 self.imageView.image = nil
                            }
                        } else {
                            self.definitionText.text = wrongAnswer
                            if let imageData = wrongImage {
                                self.imageView.image = UIImage(data:imageData as Data,scale:1.0)
                            } else if self.imageView != nil {
                                self.imageView.image = nil
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
    
    
    /**
     Function called to indicate the player has answered the question with the given input.
     */
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
        
        
        //log the activity
        print("Logging this performance:")
        let newLog = TDPerformanceLog(datetime: datetime,
                                      questionTypeId: 0,
                                      wasCorrect: wasCorrect,
                                      quizletTD: self.correctTD!,
                                      wrongAnswerTD: self.wrongTD,
                                      wrongAnswerFITB: nil,
                                      studySession: self.studySession!,
                                      context: self.frcDict[keyPerformanceLog]!.managedObjectContext)
    
        
        //check to see if the player met objectives or failed
        if didPlayerFailMission() {
            timer.invalidate() //stop timer
            self.displayMissionFinishSummary(false)
            
        } else if didPlayerCompleteMission() {
            timer.invalidate() //stop timer
            self.displayMissionFinishSummary(true)
        } else {
        
            setFeedbackVisible(visible: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {self.dismissFeedback()})
        }
    
    }
    
    /******************************************************/
    /*******************///MARK: Feedback and Display
    /******************************************************/

    /**
     Set the points in the UI
     */
    func refreshPoints() {
        pointsLabel.text = String(points)
    }
    
    /**
     Set the lives in the UI
     */
    func refreshLives() {
        
        if self.objective == GameVariantProtocols.MaxPoints {
            self.livesLabel.text = "\u{221E}"   
        } else {
            livesLabel.text = String(lives)
        }
    }
    
    /**
     Initialize the feedback message for the user
     */
    func setFeedbackMessage(wasCorrect: Bool, otherMessage: String? = nil){
        
        if wasCorrect {
            if let otherMessage = otherMessage {
                self.feedbackLabel.text = otherMessage
            } else {
                self.feedbackLabel.text = "Correct!"
            }
            
            //set color to green
            self.feedbackLabel.backgroundColor = UIColor.green
        } else {
            if let otherMessage = otherMessage {
                self.feedbackLabel.text = otherMessage
            } else {
                self.feedbackLabel.text = "Wrong!"
            }
            //set color to red
            self.feedbackLabel.backgroundColor = UIColor.red
        }
    }
    
    /**
     Presents or hides the feedback message from the player over a period of the given duration
     */
    func setFeedbackVisible(visible: Bool, duration: Float = 0.1) {
  
        if visible {
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.feedbackLabel.alpha = 1.0
            })
        } else {
            //self.feedbackLabel.text = ""
            UIView.animate(withDuration: TimeInterval(duration * 2), animations: {
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
    
    
    /**
     Hides the feedback message and presents a new question
     */
    func dismissFeedback() {
        setFeedbackVisible(visible: false)
        setupNewQuestion()
        
    }
    
    /******************************************************/
    /*******************///MARK: Button Actions
    /******************************************************/

    @IBAction func quitButtonPressed(_ sender: Any) {
        alertQuit()
    }
    
    @IBAction func trueButtonPressed(_ sender: Any) {
        answerQuestion(answer: true)
    }
    
    @IBAction func falseButtonPressed(_ sender: Any) {
        answerQuestion(answer: false)
    }
    
    func quit() {
        timer.invalidate() //stop timer
        displayMissionFinishSummary(false)
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
