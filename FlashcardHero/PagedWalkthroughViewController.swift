//
//  PagedWalkthroughViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/14/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class PagedWalkthroughViewController : UIPageViewController {
    
    
    func getStepZero() -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: "Orientation0") as! UIViewController
    }
    
    func getStepOne() -> OrientationStandardStepViewController {
        let stepStoryboard = storyboard!.instantiateViewController(withIdentifier: "OrientationStandardStepViewController") as! OrientationStandardStepViewController
        
        //screate the screen image object
        let screen = getScreenObject(screenId: 1,
                                     title: NSLocalizedString("DOWNLOADING_SETS_TITLE", comment: ""),
                                     narrative: NSLocalizedString("DOWNLOADING_SETS_NARRATIVE", comment: ""),
                                     image1: #imageLiteral(resourceName: "SetsIcon"),
                                     image2: #imageLiteral(resourceName: "UserIcon"),
                                     image3: #imageLiteral(resourceName: "PlusShot"))
        
        
        //Put this screen object into the stepStoryboard
        stepStoryboard.screenObject = screen
        
        return stepStoryboard
    }
    
    func getStepTwo() -> OrientationStandardStepViewController {
        let stepStoryboard = storyboard!.instantiateViewController(withIdentifier: "OrientationStandardStepViewController") as! OrientationStandardStepViewController
        
        //screate the screen image object
        let screen = getScreenObject(screenId: 2,
                                     title: NSLocalizedString("COMPLETING_MISSIONS_TITLE", comment: ""),
                                     narrative: NSLocalizedString("COMPLETING_MISSIONS_NARRATIVE", comment: ""),
                                     image1: #imageLiteral(resourceName: "SwitchShot"),
                                     image2: #imageLiteral(resourceName: "MissionIcon"),
                                     image3: #imageLiteral(resourceName: "GemBlue"))
        
        
        //Put this screen object into the stepStoryboard
        stepStoryboard.screenObject = screen
        
        return stepStoryboard
    }
    
    func getStepThree() -> OrientationStandardStepViewController {
        let stepStoryboard = storyboard!.instantiateViewController(withIdentifier: "OrientationStandardStepViewController") as! OrientationStandardStepViewController
        
        //screate the screen image object
        let screen = getScreenObject(screenId: 3,
                                     title: NSLocalizedString("ANALYZING_PERFORMANCE_TITLE", comment: ""),
                                     narrative: NSLocalizedString("ANALYZING_PERFORMANCE_NARRATIVE", comment: ""),
                                     image1: #imageLiteral(resourceName: "AnalysisIcon"),
                                     image2: #imageLiteral(resourceName: "Coin"),
                                     image3: #imageLiteral(resourceName: "Star"))
        
        
        //Put this screen object into the stepStoryboard
        stepStoryboard.screenObject = screen
        
        return stepStoryboard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .darkGray
        //view.backgroundColor = .clear
        
        
        
        setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
    }
    
    func getScreenObject(screenId: Int, title: String, narrative: String, image1: UIImage, image2: UIImage, image3: UIImage) -> screenObjectForOrientation {
        
        //screate the screen image object
        var screen = screenObjectForOrientation()
        
        //set the id
        screen.id = screenId
        
        //set the title
        let titleLabel = UILabel()
        titleLabel.text = title
        screen.titleLabel = titleLabel
        
        //set the narrative
        let narrativeLabel = UILabel()
        narrativeLabel.text = narrative
        screen.narrativeLabel = narrativeLabel
        
        //set first image
        let imageView1 = UIImageView(image: image1)
        screen.image1 = imageView1
        
        //set second image
        let imageView2 = UIImageView(image: image2)
        screen.image2 = imageView2
        
        //set first image
        let imageView3 = UIImageView(image: image3)
        screen.image3 = imageView3
        
        return screen
    }
}

extension PagedWalkthroughViewController : UIPageViewControllerDataSource {
    
    
    /**
     Load the card before the one showing
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vC = viewController as? OrientationStandardStepViewController {
            if vC.screenObject.id == 1 {
                //1 -> 0
                return getStepZero()
            } else if vC.screenObject.id == 2 {
                //2 -> 1
                return getStepOne()
            } else if vC.screenObject.id == 3 {
                //3 -> 2
                return getStepTwo()
            } else {
                return nil
            }
            
        } else {
            //end of the road.  It is the first view controller can't go left any more
            return nil
        }
    }
    
    /**
     Load the card after the one showing
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vC = viewController as? OrientationStandardStepViewController {
            if vC.screenObject.id == 1 {
                //1 -> 2
                return getStepTwo()
            } else if vC.screenObject.id == 2 {
                //2 -> 3
                return getStepThree()
            } else if vC.screenObject.id == 3 {
                //3 -> 4
                return nil
            } else {
                return nil
            }
            
        } else {
            //0 -> 1
            return getStepOne()
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
