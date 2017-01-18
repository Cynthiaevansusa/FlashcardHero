//
//  OrientationButton.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 1/18/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class OrientationButton: UIButton {
    
    // MARK: Properties
    
    // constants for styling and configuration
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    fileprivate func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = borderedButtonCornerRadius
    }
    
    
    // MARK: Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSize.zero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }

}
