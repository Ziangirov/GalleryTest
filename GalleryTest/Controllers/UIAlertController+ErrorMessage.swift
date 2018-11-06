//
//  UIAlertController+ErrorMessage.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 04/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(on vc: UIViewController,
                     withErrorMessageAt alert: ErrorMessage.ErrorType,
                     handler: (() -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        let title = alert.rawValue.title
        let message = alert.rawValue.message
        
        self.init(alertWith: title, message: message)
        
        self.addActionWith(title: "Ok", style: .default) { action in
            if handler != nil {
                handler!()
            }
        }
        
        if handler != nil {
            self.addActionWith(title: "Cancel", style: .cancel)
        }
        
        vc.present(self, animated: true, completion: completion)
    }
    
}
