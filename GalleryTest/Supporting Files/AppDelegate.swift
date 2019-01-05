//
//  AppDelegate.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 31/10/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var cache: URLCache = {
        let cache = URLCache.shared
        cache.memoryCapacity = URLCache.Capacity.memory
        cache.diskCapacity = URLCache.Capacity.disk
        return cache
    }()
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: - UIStateRestoration
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

private extension URLCache {
    struct Capacity {
        private init() { }
        static let memory = 16 * 1024 * 1024
        static let disk = 128 * 1024 * 1024
    }
    
}
