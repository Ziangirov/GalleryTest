//
//  ImageExtractorTests.swift
//  GalleryTestTests
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import XCTest
@testable import GalleryTest

class ImageExtractorTests: XCTestCase {

    var imageExtractor: ImageExtractor!
    
    func testImages() {
        let promise = expectation(description: "UIImages != nil")
        
        imageExtractor = ImageExtractor() { (images: [Image]?) in
            if let _ = images {
                promise.fulfill()
            } else {
                XCTFail("UIImages = nil")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testValidJSON() {
        let promise = expectation(description: "UIImages != nil")
        
//        class FakeImage: Codable {
//            let name: String
//            init(_ name: String) { self.name = name }
//        }
//        let fakeImage = FakeImage("Name")
        
        
        imageExtractor = ImageExtractor() { (images: [Image]?) in
            
            if let data = try? JSONEncoder().encode(images) {
                do {
//                    data = try! JSONEncoder().encode(fakeImage)
                    
//                    data.append(123)
                    
                    let _ = try JSONDecoder().decode([Image].self, from: data)
                    promise.fulfill()
                    
                } catch DecodingError.keyNotFound(let key, let context) {
                    XCTFail("couldn't find key \(key) in JSON: \(context.debugDescription)")
                    
                } catch DecodingError.valueNotFound(let type, let context) {
                    XCTFail("couldn't find value \(type) in JSON: \(context.debugDescription)")
                    
                } catch DecodingError.typeMismatch(let type, let context) {
                    XCTFail("couldn't find type \(type) in JSON: \(context.debugDescription)")
                    
                } catch DecodingError.dataCorrupted(let context) {
                    XCTFail("data corrupted in JSON: \(context.debugDescription)")
                    
                } catch let error {
                    XCTFail("extractData error = \(error.localizedDescription)")
                }
            } else {
                XCTFail("Data = nil")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExample() {
        XCTAssertNil(imageExtractor)
    }
    
}
