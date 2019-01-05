//
//  ErrorMessage.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 04/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

final class ErrorMessage: ExpressibleByStringLiteral {
    enum ErrorType: ErrorMessage {
        case mailServices = "Mail services are not available.|"
        case connectionError = "Image loading Failed|Couldn't load the image from its source."
    }

    typealias StringLiteralType = String
    
    let title: String
    let message: String
    
    required init(stringLiteral value: ErrorMessage.StringLiteralType) {
        let components = value.components(separatedBy: "|")
        self.title = components[0]
        self.message = components[1]
    }
    
}

extension ErrorMessage: Equatable {
    
    static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.title == rhs.title && lhs.message == rhs.message
    }
    
}
