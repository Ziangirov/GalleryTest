//
//  URL+Extensions.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

extension URL {
    static let mimeTypes = [MIMEType.jpeg, .jpg, .png]
    
    enum MIMEType: String {
        case jpeg = "image/jpeg"
        case jpg = "image/jpg"
        case png = "image/png"
    }
    
}
