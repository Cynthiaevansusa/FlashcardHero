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
    
    func getStepOne() -> OrientationViewController {
        return storyboard!.instantiateViewController(withIdentifier: "Orientation1") as! OrientationViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .darkGray
        //view.backgroundColor = .clear
        
        
        
        setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
    }
    
}

extension PagedWalkthroughViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.restorationIdentifier == "Orientation1" {
            // 0 <- 1
            return getStepOne()
        } else {
            // end of the road <- 0 
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.restorationIdentifier == "Orientation0" {
            // 0 -> 1
            return getStepOne()
        } else {
            // 2 -> end of the road
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
