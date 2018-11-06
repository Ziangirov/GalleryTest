//
//  DataFetcherTests.swift
//  GalleryTestTests
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import XCTest
@testable import GalleryTest

class DataFetcherTests: XCTestCase {
    
    var dataFetcher: DataFetcher!
    
    func testRequest() {
        let promise = expectation(description: "Request != nil")
        
        dataFetcher = DataFetcher() { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            if let _ = request {
                promise.fulfill()
            } else {
                XCTFail("Request: \(request.debugDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetValidHTTPStatusCodes() {
        let promise = expectation(description: "Status codes: 200...299")
        
        dataFetcher = DataFetcher() { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            
            if let statusCode = httpResponse?.statusCode {
                if (200...299).contains(statusCode) {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNotNilDataForJSON() {
        let promise = expectation(description: "Data for JSON is not nil")
        
        dataFetcher = DataFetcher() { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            
            if let _ = data {
                promise.fulfill()
            } else {
                XCTFail("Data for JSON = nil")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testIsValidDataForImageJSON() {
        let promise = expectation(description: "Data is Valid for ImageJSON")
        
        dataFetcher = DataFetcher() { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            
            if let data = data, let _ = try? JSONDecoder().decode([Image].self, from: data) {
                promise.fulfill()
            } else {
                XCTFail("Data is not for ImageJSON")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetValidMimeTypes() {
        let promise = expectation(description: "MimeTypes: \(URL.mimeTypes)")
        let imageURL = URL(string: "http://www.xiag.ch/share/testtask/11.jpg")!
        
        dataFetcher = DataFetcher(withImageURL: imageURL) { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            
            if URL.mimeTypes.map({ $0.rawValue }).contains(httpResponse?.mimeType) {
                promise.fulfill()
            } else {
                XCTFail("Wrong mimeType")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataForImage() {
        let promise = expectation(description: "UIImage from Data: exist")
        let imageURL = URL(string: "http://www.xiag.ch/share/testtask/16.jpg")!
        
        dataFetcher = DataFetcher(withImageURL: imageURL) { (request: URLRequest?, data: Data?, httpResponse: HTTPURLResponse?) in
            
            if let data = data, let _ = UIImage(data: data) {
                promise.fulfill()
            } else {
                XCTFail("UIImage from Data: not exist")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExample() {
        XCTAssertNil(dataFetcher)
    }

}
