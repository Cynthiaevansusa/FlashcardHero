//
//  CustomQuizletSearchBySetsResultsCell.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/1/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class CustomQuizletSearchBySetsResultsCell: UITableViewCell {
    
    //label
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var termCount: UILabel!
    
    @IBOutlet weak var customDescription: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    
    //QuizletSetSearchResult
    var quizletSetSearchResult : QuizletSetSearchResult? {
        didSet {
            //try to set the label
            if let title = quizletSetSearchResult?.title {
                self.title.text = title
            }
            
            //try to set the detailTextLabel
            if let description = quizletSetSearchResult?.description {
                self.customDescription.text = description
            }
            
            //try to set the detailTextLabel
            if let termCount = quizletSetSearchResult?.term_count {
                self.termCount.text = String(termCount)
            }
            
            //try to set the detailTextLabel
            if let creator = quizletSetSearchResult?.created_by {
                self.creator.text = creator
            }
            
            
            //try to set the description
//            if let description = quizletSetSearchResult?.description {
//                self.description. = description
//            }
            
            //try to set the photo
            
//            if let imageData = quizletSetSearchResult?.imageData {
//                self.imageView?.image = UIImage(data:imageData as Data,scale:1.0)
//            } else {
//                self.imageView?.image = nil
//            }
        }
        
    }
}
