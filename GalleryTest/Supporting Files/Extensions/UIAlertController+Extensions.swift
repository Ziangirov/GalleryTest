//
//  UIAlertController+Extensions.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(alertWith title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
    }
    
}

extension UIAlertController {
    func addActionWith(title: String,
                       style: UIAlertAction.Style = .default,
                       handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}
