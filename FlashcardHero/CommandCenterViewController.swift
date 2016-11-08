//
//  FirstViewController.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import UIKit
//import Charts

class CommandCenterViewController: UIViewController {


    @IBOutlet weak var playTrueFalseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    @IBAction func playTrueFalseButtonPressed(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameTrueFalse")
        //vc.quizletIngestDelegate = self
        
        present(vc!, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

