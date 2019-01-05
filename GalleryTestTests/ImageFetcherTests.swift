//
//  ImageFetcherTests.swift
//  GalleryTestTests
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import XCTest
@testable import GalleryTest

class ImageFetcherTests: XCTestCase {
    
    var imageFetcher: ImageFetcher!
    
    func testImage() {
        let promise = expectation(description: "UIImage != nil")
        let url = URL(string: "http://www.xiag.ch/share/testtask/16.jpg")!
        
        imageFetcher = ImageFetcher(withImageURL: url) { (image: UIImage?) in
            if let _ = image {
                promise.fulfill()
            } else {
                XCTFail("UIImage = nil")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNilImage() {
        let promise = expectation(description: "UIImage = nil")
        let url = URL(string: "http://www.xiag.ch/share/testtask/")!
        
        imageFetcher = ImageFetcher(withImageURL: url) { (image: UIImage?) in
            if image == nil {
                promise.fulfill()
            } else {
                XCTFail("UIImage != nil")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExample() {
        XCTAssertNil(imageFetcher)
    }
 
}
