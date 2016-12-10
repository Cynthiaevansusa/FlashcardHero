//
//  OrientationViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/10/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class OrientationViewController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var gettingStartedHeadingLabel: UILabel!
    @IBOutlet weak var gettingStartedBodyLabel: UILabel!
    
    @IBOutlet weak var downloadHeadingLabel: UILabel!
    @IBOutlet weak var downloadBodyLabel: UILabel!
    @IBOutlet weak var downloadImage1: UIImageView!
    @IBOutlet weak var downloadImage2: UIImageView!
    @IBOutlet weak var downloadImage3: UIImageView!
    
    @IBOutlet weak var missionsHeadingLabel: UILabel!
    @IBOutlet weak var missionsBodyLabel: UILabel!
    @IBOutlet weak var missionsImage1: UIImageView!
    @IBOutlet weak var missionsImage2: UIImageView!
    @IBOutlet weak var missionsImage3: UIImageView!
    
    @IBOutlet weak var analysisHeadingLabel: UILabel!
    @IBOutlet weak var analysisBodyLabel: UILabel!
    @IBOutlet weak var analysisImage1: UIImageView!
    @IBOutlet weak var analysisImage2: UIImageView!
    @IBOutlet weak var analysisImage3: UIImageView!
    
    
    /******************************************************/
    /*******************///MARK: Life Cycle
    /******************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeEverything(alpha: 0.0)
        
        animatedSequence()
    }
    
    /******************************************************/
    /*******************///MARK: Utilities
    /******************************************************/

    func animatedSequence() {
       
        //heading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 3.0, animations: {
                self.headingLabel.alpha = 1
            })
            
        }
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.gettingStartedHeadingLabel.alpha = 1
            })

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            UIView.animate(withDuration: 4.0, animations: {
                self.gettingStartedBodyLabel.alpha = 1
            })
            
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 18.7) {
            UIView.animate(withDuration: 5.0, animations: {
                self.gettingStartedBodyLabel.alpha = 0
                self.gettingStartedHeadingLabel.alpha = 0
                
            })
            
            
        }
        
        //download section
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 22.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.downloadHeadingLabel.alpha = 1
                self.dismissButton.alpha = 1
                
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 24.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.downloadBodyLabel.alpha = 1
                
            })
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
            UIView.animate(withDuration: 3.0, animations: {
                self.downloadImage1.alpha = 1.0
                self.downloadImage2.alpha = 1.0
                self.downloadImage3.alpha = 1.0
            })
            
        }
        
        //missions section
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 32.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.missionsHeadingLabel.alpha = 1
                
                self.downloadHeadingLabel.alpha = 0.8
                self.downloadBodyLabel.alpha = 0.8
                self.downloadImage1.alpha = 0.8
                self.downloadImage2.alpha = 0.8
                self.downloadImage3.alpha = 0.8
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 34.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.missionsBodyLabel.alpha = 1
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 35.0) {
            UIView.animate(withDuration: 3.0, animations: {
                self.missionsImage1.alpha = 1.0
                self.missionsImage2.alpha = 1.0
                self.missionsImage3.alpha = 1.0
            })
            
        }
        
        //analysis section

        DispatchQueue.main.asyncAfter(deadline: .now() + 42.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.analysisHeadingLabel.alpha = 1
                
                self.missionsHeadingLabel.alpha = 0.8
                self.missionsBodyLabel.alpha = 0.8
                self.missionsImage1.alpha = 0.8
                self.missionsImage2.alpha = 0.8
                self.missionsImage3.alpha = 0.8
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 44.5) {
            UIView.animate(withDuration: 3.0, animations: {
                self.analysisBodyLabel.alpha = 1
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 45.0) {
            UIView.animate(withDuration: 3.0, animations: {
                self.analysisImage1.alpha = 1.0
                self.analysisImage2.alpha = 1.0
                self.analysisImage3.alpha = 1.0
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 50.0) {
            UIView.animate(withDuration: 3.0, animations: {
                self.downloadHeadingLabel.alpha = 1.0
                self.downloadBodyLabel.alpha = 1.0
                self.downloadImage1.alpha = 1.0
                self.downloadImage2.alpha = 1.0
                self.downloadImage3.alpha = 1.0
                
                self.missionsHeadingLabel.alpha = 1.0
                self.missionsBodyLabel.alpha = 1.0
                self.missionsImage1.alpha = 1.0
                self.missionsImage2.alpha = 1.0
                self.missionsImage3.alpha = 1.0
                
            })
            
        }
    
        
        
    }
    
    func showButton() {
        
    }
    
    func makeEverything(alpha: CGFloat) {
        headingLabel.alpha = alpha
        dismissButton.alpha = alpha
        
        gettingStartedHeadingLabel.alpha = alpha
        gettingStartedBodyLabel.alpha = alpha
        
        downloadHeadingLabel.alpha = alpha
        downloadBodyLabel.alpha = alpha
        downloadImage1.alpha = alpha
        downloadImage2.alpha = alpha
        downloadImage3.alpha = alpha
        
        missionsHeadingLabel.alpha = alpha
        missionsBodyLabel.alpha = alpha
        missionsImage1.alpha = alpha
        missionsImage2.alpha = alpha
        missionsImage3.alpha = alpha
        
        analysisHeadingLabel.alpha = alpha
        analysisBodyLabel.alpha = alpha
        analysisImage1.alpha = alpha
        analysisImage2.alpha = alpha
        analysisImage3.alpha = alpha
    }
    
    /******************************************************/
    /*******************///MARK: Actions
    /******************************************************/

    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "Walkthrough")
        dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
    
    
}
