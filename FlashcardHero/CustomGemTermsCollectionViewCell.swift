//
//  CustomGemTermsCollectionViewCell.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/3/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class CustomGemTermsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var term: UILabel!
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var definition: UILabel!
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var quizletTerm: QuizletTermDefinition? {
        didSet {
            //try to set the label
            if let term = quizletTerm?.term {
                self.term.text = term
            } else {
                self.term.text = ""
            }
            
            //try to set the definition
            if let definition = quizletTerm?.definition {
                self.definition.text = definition
            } else {
                self.definition.text = ""
            }
            
            //try to set the definition
            if let rank = quizletTerm?.rank {
                self.rank.text = String(describing: (rank + 1))
            } else {
                self.rank.text = ""
            }
            
            //try to set the photo
            if let imageData = quizletTerm?.imageData {
                self.imageView?.image = UIImage(data:imageData as Data,scale:1.0)
            } else {
                self.imageView?.image = nil
            }
            
        }
    }
    
    func startActivityIndicator() {
        self.activityIndicator!.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator!.stopAnimating()
    }
    
    
}
