//
//  CustomMissionCollectionViewCell.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class CustomMissionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var objective: UILabel!
    @IBOutlet weak var reward: UILabel!
    @IBOutlet weak var gameTypeIcon: UIImageView!
    @IBOutlet weak var level: UILabel!
    
    
    @IBOutlet weak var gemSectionsExercised: UIImageView!
    
    @IBOutlet weak var startMissionButton: UIButton!
    
    var gameVariant: GameVariant? {
        didSet {
            
            //try to set the photo
            if let image = gameVariant?.game.icon {
                self.gameTypeIcon?.image = image
            } else {
                self.gameTypeIcon?.image = nil
            }
            
            //subtitle
            if let subtitle = gameVariant?.game.description {
                self.subtitle?.text = subtitle
            } else {
                self.subtitle?.text = nil
            }
            
            self.name.text = gameVariant?.game.name
            
            //button styling
            startMissionButton.layer.masksToBounds = true
            startMissionButton.layer.cornerRadius = CGFloat(6.0)
        }
    }
    
    
}
