//
//  Fetcher.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class DataFetcher {
    deinit { session.invalidateAndCancel() }
    
    private enum ObjectType {
        case json
        case image
    }
    
    private var handler: (URLRequest?, Data?, HTTPURLResponse?) -> Void
    private lazy var session: URLSession = { return URLSession.shared }()
    
    init(_ handler: @escaping (URLRequest?, Data?, HTTPURLResponse?) -> Void) {
        self.handler = handler
        getDataFor(.json, from: URL.jsonURL)
    }
    
    init(withImageURL url: URL, handler: @escaping (URLRequest?, Data?, HTTPURLResponse?) -> Void) {
        self.handler = handler
        getDataFor(.image, from: url)
    }
    
    private func getDataFor(_ type: ObjectType, from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self != nil {
                let request = URLRequest(url: url)
                
                let task = self?.session.dataTask(with: request) { (data, response, error) in
                    NotificationCenter.notifyIfError(error)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                        URL.validStatusCodes.contains(httpResponse.statusCode) else {
                            self?.handler(nil, nil, nil)
                            return
                    }
                    guard let data = data else { return }
                    self?.handler(request, data, httpResponse)
                }
                
                switch type {
                case .image:
                    guard let data = AppDelegate.cache.cachedResponse(for: request)?.data, let _ = UIImage(data: data) else { fallthrough }
                    self?.handler(request, data, nil)
                case .json:
                    task?.resume()
                }
            } else {
                print("DataFetcher: returned but I've left the heap -- ignoring result.")
            }
        }
    }
}

private extension URL {
    static let validStatusCodes = (200...299)
    static let jsonURL = URL(string: "http://www.xiag.ch/share/testtask/list.json")!
    
}

extension Notification.Name {
    static let DownloadError = Notification.Name("DownloadError")
}
