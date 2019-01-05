//
//  ImageExtractor.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class ImageExtractor {
    private var handler: ([Image]?) -> Void
    private var dataFetcher: DataFetcher!
    
    init(_ completion: @escaping ([Image]?) -> Void) {
        handler = completion
        
        try? extractData()
    }
    
    private func extractData() throws {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self != nil {
                self?.dataFetcher = DataFetcher() { _, data, _ in
                    guard let data = data else { self?.handler(nil); return }
                    
                    do {
                        let json = try JSONDecoder().decode([Image].self, from: data)
                        self?.handler(json)
                        
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("couldn't find key \(key) in JSON: \(context.debugDescription)")
                        
                    } catch DecodingError.valueNotFound(let type, let context) {
                        print("couldn't find value \(type) in JSON: \(context.debugDescription)")
                        
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("couldn't find type \(type) in JSON: \(context.debugDescription)")
                        
                    } catch DecodingError.dataCorrupted(let context) {
                        print("data corrupted in JSON: \(context.debugDescription)")
                        
                    } catch let error {
                        print("extractData error = \(error.localizedDescription)")
                    }
                }
            } else {
                print("ImageExtractor: returned but I've left the heap -- ignoring result.")
            }
        }
    }
    
}
