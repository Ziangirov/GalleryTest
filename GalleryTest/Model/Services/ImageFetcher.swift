//
//  ImageFetcher.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class ImageFetcher {
    private var handler: (UIImage?) -> Void
    private var dataFetcher: DataFetcher?
    
    func cancelLoading() {
        dataFetcher?.cancelLoading()
    }
    
    init(withImageURL url: URL, handler: @escaping (UIImage?) -> Void) {
        self.handler = handler
        
        fetchURL(url)
    }
    
    private func fetchURL(_ url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self != nil {
                self?.dataFetcher = DataFetcher(withImageURL: url) { request, data, httpResponse in
                    guard let data = data else {
                        self?.handler(nil)
                        return
                    }
                    switch httpResponse {
                    case let httpResponse where httpResponse != nil &&
                        URL.mimeTypes.map { $0.rawValue }.contains(httpResponse!.mimeType):
                        
                        let cachedData = CachedURLResponse(response: httpResponse!, data: data)
                        AppDelegate.cache.storeCachedResponse(cachedData, for: request!)
                        fallthrough
                    case nil:
                        if let image = UIImage(data: data) {
                            self?.handler(image)
                        } else {
                            fallthrough
                        }
                    default:
                        self?.handler(nil)
                        break
                    }
                }
            } else {
                self?.handler(nil)
                print("ImageFetcher: returned but I've left the heap -- ignoring result.")
            }
        }
    }
    
}
