//
//  CustomGemManagerCell.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

protocol SettingCellDelegate: class {
    func didChangeSwitchState(sender: CustomGemManagerCell, isOn: Bool)
}

class CustomGemManagerCell: UITableViewCell {
    
    //label
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var termCount: UILabel!
    
    @IBOutlet weak var customDescription: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var cellDelegate: SettingCellDelegate?
    
    //QuizletSetSearchResult
    var quizletSet : QuizletSet? {
        didSet {
            //try to set the label
            if let title = quizletSet?.title {
                self.title.text = title
            }
            
            //try to set the detailTextLabel
            if let description = quizletSet?.setDescription {
                self.customDescription.text = description
            }
            
            //try to set the detailTextLabel
            if let termCount = quizletSet?.termCount {
                self.termCount.text = String(termCount)
            }
            
            //try to set the detailTextLabel
            if let creator = quizletSet?.createdBy {
                self.creator.text = creator
            }
            
            if let isSwitchOn = quizletSet?.isActive {
                self.activeSwitch.isOn = isSwitchOn
            }
        
        }
        
    }
    
    @IBAction func handledSwitchChange(sender: UISwitch) {
        self.cellDelegate?.didChangeSwitchState(sender: self, isOn: activeSwitch.isOn)
        
    }
    
    func startActivityIndicator() {
        self.activityIndicator!.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator!.stopAnimating()
    }
}
