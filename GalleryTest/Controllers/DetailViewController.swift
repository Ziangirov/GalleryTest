//
//  DetailViewController.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit
import MessageUI

final class DetailViewController: UIViewController {
    private static let storyboardName = "MainStoryboard"
    private static let viewControllerIdentifier = "DetailViewController"
    
    private static let restoreImage = "restoreImageKey"
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet private weak var spiner: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    private var alertController: UIAlertController!
    private var imageFetcher: ImageFetcher!
    
    var image: Image? {
        didSet {
            imageView.image = nil
            if view.window != nil {
                fetchURL()
            }
        }
    }
    
    private var isLoading = false {
        didSet {
            if isLoading {
                spiner?.isHidden = false
                spiner?.startAnimating()
            } else {
                spiner?.isHidden = true
                spiner?.stopAnimating()
            }
        }
    }
    
    private func fetchURL() {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let url = image?.imgURL else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        imageFetcher = ImageFetcher(withImageURL: url) { [weak self] image in
            DispatchQueue.main.async {
                if image == nil {
                    self?.isLoading = false
                }
                self?.imageView.setupOnScrollView(self?.scrollView,
                                                  height: self?.scrollViewHeight,
                                                  width: self?.scrollViewWidth,
                                                  image: image,
                                                  in: self?.containerView)
                self?.isLoading = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        isLoading = false
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(compose))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
        title = image?.title
        
        if imageView.image == nil {
            fetchURL()
        }
    }
    
    private func setupScrollView() {
        scrollView?.minimumZoomScale = 0.25
        scrollView?.maximumZoomScale = 5.0
        scrollView?.delegate = self
    }
    
    @objc class func detailViewControllerForImage(_ image: Image) -> UIViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)
        
        let viewController = storyboard
            .instantiateViewController(withIdentifier: DetailViewController.viewControllerIdentifier)
        
        let navController = UINavigationController(rootViewController: viewController)
        
        if let detailViewController = viewController as? DetailViewController {
            detailViewController.image = image
        }
        
        return navController
    }
    
    @objc func compose(_ sender: UIBarButtonItem) {
        if !MFMailComposeViewController.canSendMail() {
            
            alertController = UIAlertController(on: self, withErrorMessageAt: .mailServices)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello from GalleryTest!", isHTML: false)
        
        guard let url = image?.imgURL else { return }
        
        imageFetcher = ImageFetcher(withImageURL: url) { image in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    composeVC.addAttachmentData(data,
                                                mimeType: URL.MIMEType.jpeg.rawValue,
                                                fileName: self?.image?.title ?? "fileName")
                }
                
                DispatchQueue.main.async {
                    if let alert = self?.presentedViewController {
                        alert.dismiss(animated: true, completion: {
                            self?.present(composeVC, animated: true, completion: nil)
                        })
                    } else {
                        self?.present(composeVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
}

// MARK: - UIStateRestoration

extension DetailViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(image, forKey: DetailViewController.restoreImage)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let decodedImage = coder.decodeObject(forKey: DetailViewController.restoreImage) as? Image {
            image = decodedImage
        } else {
            fatalError("An Image did not exist.")
        }
    }
    
}
