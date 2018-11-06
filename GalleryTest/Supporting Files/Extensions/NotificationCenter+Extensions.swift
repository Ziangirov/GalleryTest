//
//  NotificationCenter+Extensions.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

extension NotificationCenter {
    static func notifyIfError(_ error: Error?) {
        guard let error = error else { return }
        let key = Notification.Name.DownloadError
        self.default.post(name: key, object: nil, userInfo: [key: error])
    }
}

extension NotificationCenter {
    static func observeAndGet<T>(_ name: Notification.Name, completion: @escaping (T) -> Void) {
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: nil) { notification in
                guard let value = notification.valueOfType(T.self, forKey: name) else { return }
                
                completion(value)
        }
    }
    
}

private extension Notification {
    func valueOfType<T>(_ type: T.Type, forKey: Notification.Name) -> T? {
        guard let userInfo = userInfo else { return nil }
        switch userInfo.keys {
            
        case let userKeys where userKeys.contains(forKey):
            return userInfo[forKey] as? T
            
        default:
            return nil
        }
    }
    
}
