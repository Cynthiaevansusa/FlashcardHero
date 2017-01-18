//
//  OrientationFirstStepViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 1/18/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
/**
 Holds and manages the information for the first orientation screen
 */
class OrientationFirstStepViewController: UIViewController {
    
    
    @IBOutlet weak var dismissButton: UIButton!
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(25.0)
        
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            dismissButton.isHidden = false
            dismissButton.isEnabled = true
        } else {
            dismissButton.isHidden = true
            dismissButton.isEnabled = false
        }

    }
    
    @IBAction func dismissButtonWasPushed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "Walkthrough")
        dismiss(animated: true, completion: nil)
    }
    
}
