//
//  OrientationStandardStepViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/14/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit


/**
 Holds and manages the information for the standard orientation screens, where each screen has a title, a narrative, and three graphics.
 
 - Parameters:
 - Assumes that screenObject is set before loading, set with the screenObjectForOrientation struct for the screen to be displayed.
 */
class OrientationStandardStepViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var narrativeLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    var screenObject: screenObjectForOrientation!

    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(25.0)
        
        loadScreen(screenObject)
        
    }
    
    func loadScreen(_ screen: screenObjectForOrientation) {
        
        titleLabel.text = screen.titleLabel.text
        narrativeLabel.text = screen.narrativeLabel.text
        image1.image = screen.image1.image
        image2.image = screen.image2.image
        image3.image = screen.image3.image
    }
    
}

struct screenObjectForOrientation {
    var id: Int!
    var titleLabel: UILabel!
    var narrativeLabel: UILabel!
    var image1: UIImageView!
    var image2: UIImageView!
    var image3: UIImageView!
}
