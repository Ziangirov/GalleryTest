//
//  UIView+Extensions.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

extension UIColor {
    static let lead = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    static let clover = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
    
}

extension UIColor {
    enum Identifier: String {
        case clover, lead
    }
    
    convenience init(_ asset: Identifier) {
        self.init(named: asset.rawValue)!
    }
    
}

extension UIView {
    func animatedAppearing() {
        let cellTransformation = CATransform3DTranslate(CATransform3DIdentity, -150, 80, 0)
        self.layer.transform = cellTransformation
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction, .preferredFramesPerSecond60],
                       animations: { [weak self] in
                        self?.alpha = 1
                        self?.layer.transform = CATransform3DIdentity
        })
    }
    
}
