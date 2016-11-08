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

class GameTrueFalseViewController: CoreDataTrueFalseGameController {

    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    @IBOutlet weak var termText: UILabel!
    @IBOutlet weak var definitionText: UILabel!

    @IBOutlet weak var feedbackLabel: UILabel!
    
    var showingCorrectAnswer: Bool = false
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        
        setupNewQuestion()
        
    }
    
    
    /******************************************************/
    /*******************///MARK: Game Functions
    /******************************************************/

    func setupNewQuestion() {
        //pick a random term
        if let fc = fetchedResultsController {
            print((fc.fetchedObjects?.count)!)
            
            if (fc.fetchedObjects?.count)! > 0 {
                
                let numberOfTerms = fc.fetchedObjects?.count
                
                let randIndex = 0
                
                if let sets = fc.fetchedObjects {
                    let quizletSet = sets[randIndex] as! QuizletSet
                    
                    //now get a random question from the set
                    
                    let randTermIndex = 0
                    
                    setupTermDefinitionFetchedResultsController(set: quizletSet)
                    
                    if let tfc = termFetchedResultsController {
                        if (tfc.fetchedObjects?.count)! > 0 {
                             if let terms = tfc.fetchedObjects {
                                
                                let quizletTermDefinition = terms[randTermIndex] as! QuizletTermDefinition
                                
                                let question = quizletTermDefinition.term
                                let correctAnswer = quizletTermDefinition.definition
                                
                                //get a random definition
                                let randDefinitionIndex = 0
                                let wrongQuizletTermDefinition = terms[randDefinitionIndex] as! QuizletTermDefinition
                                
                                let wrongAnswer = wrongQuizletTermDefinition.definition
                                
                                //set the question
                                self.termText.text = question
                                
                                //determine if will show correct answer
                                
                                let willShowCorrect = true
                                
                                if willShowCorrect {
                                    self.definitionText.text = correctAnswer
                                    self.showingCorrectAnswer = willShowCorrect
                                } else {
                                    self.definitionText.text = wrongAnswer
                                    self.showingCorrectAnswer = !willShowCorrect
                                }
                                
                                
                                
                                
                             } else {
                                //TODO: Handle Error
                            }
                
                            
                        } else {
                            //TODO: Handle Error
                        }
                        
                    } else {
                        //TODO: Handle Error
                    }
                    
                } else {
                    //TODO: Handle error
                }
                
            } else {
                //TODO: handle error
            }
        }
    }
    
    func answerQuestion(answer: Bool) {
        //check the correct answer
        
        if (answer && showingCorrectAnswer) || (!answer && !showingCorrectAnswer) {
            //they answered correctly
            setFeedbackVisible(visible: true, wasCorrect: true)
        } else {
            //answered incorrectly
            setFeedbackVisible(visible: true, wasCorrect: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {self.dismissFeedback()})
    }
    
    /******************************************************/
    /*******************///MARK: Feedback
    /******************************************************/

    func setFeedbackVisible(visible: Bool, wasCorrect: Bool = false) {
        if wasCorrect {
            self.feedbackLabel.text = "Correct!"
        } else {
            self.feedbackLabel.text = "Wrong!"
        }
        
        if visible {
            UIView.animate(withDuration: 0.3, animations: {
                self.feedbackLabel.alpha = 1.0
            })
        } else {
            self.feedbackLabel.text = ""
            UIView.animate(withDuration: 1.0, animations: {
                self.feedbackLabel.alpha = 0.0
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trueButtonPressed(_ sender: Any) {
        answerQuestion(answer: true)
    }
    
    @IBAction func falseButtonPressed(_ sender: Any) {
        answerQuestion(answer: false)
    }
    
    

    /******************************************************/
    /******************* Model Operations **************/
    /******************************************************/
    //MARK: - Model Operations
    
    func setupFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizletSet")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
        //only get sets that are active
        //let pred = NSPredicate(format: "isActive = %@", argumentArray: ["true"])

        //fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = fc
        
    }
    
    func setupTermDefinitionFetchedResultsController(set: QuizletSet){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizletTermDefinition")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
        //only get sets that are active
        let pred = NSPredicate(format: "quizletSet = %@", argumentArray: [set])
        
        fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.termFetchedResultsController = fc
        
    }
    
    func fetchModelQuizletSets() -> [QuizletSet] {
        return fetchedResultsController!.fetchedObjects as! [QuizletSet]
    }
    
    func fetchQuizletTermDefinitions(set: QuizletSet) -> [QuizletTermDefinition] {
        
        setupTermDefinitionFetchedResultsController(set: set)
        
        return termFetchedResultsController!.fetchedObjects as! [QuizletTermDefinition]
    }
}
