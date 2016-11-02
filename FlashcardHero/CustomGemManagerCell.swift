//
//  CustomGemManagerCell.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class CustomGemManagerCell: UITableViewCell {
    
    //label
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var termCount: UILabel!
    
    @IBOutlet weak var customDescription: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    
    //QuizletSetSearchResult
    var quizletSet : QuizletSet? {
        didSet {
            //try to set the label
            if let title = quizletSet?.title {
                self.title.text = title
            }
            
            //try to set the detailTextLabel
            if let description = quizletSet?.description {
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
            
        }
        
    }
}
