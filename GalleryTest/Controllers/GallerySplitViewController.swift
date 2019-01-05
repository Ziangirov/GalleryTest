//
//  GallerySplitViewController.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class GallerySplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private weak var alertController: UIAlertController!
    private var suppressBadURLWarnings = false
    
    private(set) var errorURL: Error? = nil {
        didSet {
            guard alertController == nil, !suppressBadURLWarnings else { return }
            
            alertController = UIAlertController(on: self) {
                self.suppressBadURLWarnings = true
            }
            
            viewControllers.forEach {
                guard !alertController.isBeingPresented else { return }
                switch $0.contents {
                    
                case let detailVC as DetailViewController
                    where detailVC.view.window != nil:
                    detailVC.present(alertController, animated: true)
                    
                case let mainTVC as MainTableViewController
                    where mainTVC.view.window != nil &&
                        mainTVC.searchController.view.window == nil:
                    guard !mainTVC.searchController.isActive else { break }
                    
                    mainTVC.present(alertController, animated: true)

                default:
                    break
                }
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lead
        
        delegate = self
        preferredDisplayMode = .primaryOverlay
        
        NotificationCenter.observeAndGet(.DownloadError) { result in
            DispatchQueue.main.async {
                self.errorURL = result
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        preferredDisplayMode = .automatic
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
    
}

private extension UIAlertController {
    convenience init?(on vc: UIViewController, _ completion: (()->())? = nil) {
        guard let error = (vc as? GallerySplitViewController)?.errorURL else { return nil }
        
        self.init(alertWith:error.localizedDescription,
                  message: "Couldn't load image from its source.\nShow this warning in the future?")
        
        self.addActionWith(title: "Keep Warning", style: .default)
        self.addActionWith(title: "Stop Warning", style: .destructive) { _ in
            
            if completion != nil {
                completion!()
            }
        }
    }
    
}
