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

extension UIView {
    func appearAnimated() {
        self.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction, .preferredFramesPerSecond60],
                       animations: { [weak self] in
                        self?.alpha = 1
        })
    }
    
}
