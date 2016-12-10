//
//  MissionFeedbackViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/9/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol MissionFeedbackDelegate {
    func setupWith(wasSuccess: Bool, numStars: Int, timeElapsedString time: String, totalPoints points: Int, accurracy: Double, customStats stats: [String:Any]?, senderVC sender: UIViewController, destinationVC:UIViewController?,  vCCompletion: (() -> Void)?)
}

class MissionFeedbackViewController: CoreDataQuizletCollectionViewController, MissionFeedbackDelegate {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var accurracyLabel: UILabel!
    @IBOutlet weak var customLabel1: UILabel!
    @IBOutlet weak var customLabel2: UILabel!
    @IBOutlet weak var customStatLabel1: UILabel!
    @IBOutlet weak var customStatLabel2: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    
    var destinationVC: UIViewController!
    var senderVC: UIViewController!
    var destinationVCCompletion: (() -> Void)?
    
    var summaryLabelText = ""
    var numStars = 0
    var timeElapsedLabelText = ""
    var totalPointsLabelText = ""
    var accurracyLabelText = ""
    var customLabel1Text = ""
    var customLabel2Text = ""
    var customStatLabel1Text = ""
    var customStatLabel2Text = ""
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryLabel.text = summaryLabelText
        
        switch numStars {
        case 0:
            //highlight 0 stars
            starHighlighter(0)
        case 1:
            //highlight 1 star
            starHighlighter(1)
        case 2:
            //highlight 2 stars
            starHighlighter(2)
        case 3:
            //highlight 3 stars
            starHighlighter(3)
        default:
            //highlight 0 stars
            starHighlighter(0)
        }
        
        timeElapsedLabel.text = timeElapsedLabelText
        totalPointsLabel.text = totalPointsLabelText
        accurracyLabel.text = accurracyLabelText
        
        
        customLabel1.text = customLabel1Text
        customLabel2.text = customLabel2Text
        customStatLabel1.text = customStatLabel1Text
        customStatLabel2.text = customStatLabel2Text
        
        
        //show or hide the custom stats
        if customLabel1.text != nil && customStatLabel1.text != nil {
            customLabel1.isHidden = false
            customStatLabel1.isHidden = false
        } else {
            customLabel1.isHidden = true
            customStatLabel1.isHidden = true
        }
        
        if customLabel2.text != nil && customStatLabel2.text != nil {
            customLabel2.isHidden = false
            customStatLabel2.isHidden = false
        } else {
            customLabel2.isHidden = true
            customStatLabel2.isHidden = true
        }
    }
    
    
   
    
    /******************************************************/
    /*******************///MARK: MissionFeedbackDelegate
    /******************************************************/

    /**
     Delegate method used by anything that calls this view, should do so with this method in closure.
     */
    func setupWith(wasSuccess: Bool, numStars: Int, timeElapsedString time: String, totalPoints points: Int, accurracy: Double, customStats stats: [String:Any]? = nil, senderVC sender: UIViewController, destinationVC:UIViewController? = nil,  vCCompletion: (() -> Void)? = nil){
        
        if wasSuccess {
            summaryLabelText = "Success!"
        } else {
            summaryLabelText = "Failed!"
        }
        
        self.numStars = numStars
        
        timeElapsedLabelText = time
        
        totalPointsLabelText = String(describing: points)
        
        
        if accurracy.isNaN || accurracy.isFinite {
            accurracyLabelText = "--"
        } else {
            let aValue = Int(round(accurracy * 100))
            accurracyLabelText = "\(aValue)%"
        }
        
        senderVC = sender
        
        //if didn't supply a destination, then assume destination is back to sender
        if let destinationVC = destinationVC {
            self.destinationVC = destinationVC
        } else {
            self.destinationVC = sender
        }
        
        self.destinationVCCompletion = vCCompletion
        
        //handle the first two custom stats
        if let stats = stats {
            customLabel1Text = ""

            for (statLabel, statValue) in stats {
                if customLabel1Text == "" {
                    customLabel1Text = statLabel
                    customStatLabel1Text = String(describing: statValue)
                } else { //if the first label is nil, do the second label
                    customLabel2Text = statLabel
                    customStatLabel2Text = String(describing: statValue)
                }
            }
        }
        

    }
    
    func starHighlighter(_ numStars: Int) {
        guard numStars <= 3 && numStars >= 0 else {
            print("Invalid number of stars to highlight \(numStars)")
            return
        }
        
        switch numStars {
        case 0:
            //don't highlight anything, keep all gray
            starHighlight(star: 1, doHighlight: false)
            starHighlight(star: 2, doHighlight: false)
            starHighlight(star: 3, doHighlight: false)
        case 1:
            starHighlight(star: 1, doHighlight: true)
            starHighlight(star: 2, doHighlight: false)
            starHighlight(star: 3, doHighlight: false)
        case 2:
            starHighlight(star: 1, doHighlight: true)
            starHighlight(star: 2, doHighlight: true)
            starHighlight(star: 3, doHighlight: false)
        case 3:
            starHighlight(star: 1, doHighlight: true)
            starHighlight(star: 2, doHighlight: true)
            starHighlight(star: 3, doHighlight: true)
        default:
            return
        }
    }
    
    func starHighlight(star:Int, doHighlight: Bool) {
        guard star <= 3 && star >= 1 else {
            print("Requested to highlight invalid star number \(star)")
            return
        }
        
        var starToHighlight: UIImageView
        switch star {
        case 1:
            starToHighlight = star1
        case 2:
            starToHighlight = star2
        case 3:
            starToHighlight = star3
        default:
            return
        }
        
        if doHighlight {
            starToHighlight.image = #imageLiteral(resourceName: "Star")
        } else {
            starToHighlight.image = #imageLiteral(resourceName: "StarGray")
        }
    }
    
    
    
    /******************************************************/
    /*******************///MARK: Actions
    /******************************************************/
    
    @IBAction func okButtonPressed(_ sender: Any) {
        
        if senderVC == destinationVC {
            //TODO: Improve visuals of this transition
            
            self.senderVC.dismiss(animated: false, completion: self.destinationVCCompletion)
            self.dismiss(animated: true, completion: nil)
        } else { //needs to be send elsewhere 
            //TODO: Improve this for user
            self.dismiss(animated: false, completion: { self.present(self.destinationVC, animated: false, completion: self.destinationVCCompletion)})
        }
        
        
    }
    

}
