//
//  OrientationFinalStepViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 1/18/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
/**
 Holds and manages the information for the final orientation screen
 */
class OrientationFinalStepViewController: UIViewController {
    
    
    @IBOutlet weak var proceedButton: UIButton!
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(25.0)
        
    }

    @IBAction func proceedButtonWasPushed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "Walkthrough")
        dismiss(animated: true, completion: nil)
    }
    
}
