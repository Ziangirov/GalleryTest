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
    private static let restoreViewModel = "restoreViewModel"
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet private weak var spiner: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    private var alertController: UIAlertController!
    
    private var viewModel: DetailViewModel?
    
    private var isLoading = false {
        didSet {
            isLoading ? spiner.startAnimating() : spiner.stopAnimating()
        }
    }
    
    func setupViewModelForImage(_ image: Image) {
        viewModel = DetailViewModel(withImage: image) { [weak self] state in
            switch state {
            case .startLoading:
                DispatchQueue.main.async {
                    self?.isLoading = true
                    self?.title = self?.viewModel?.imageModel.title
                }
            case .downloaded:
                DispatchQueue.main.async {
                    self?.imageView.setupOnScrollView(self?.scrollView, height: self?.scrollViewHeight, width: self?.scrollViewWidth, image: self?.viewModel?.uiImage, in: self?.containerView)
                    self?.isLoading = false
                }
            case .finishedOnError:
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.alertController = UIAlertController(on: self!, withErrorMessageAt: .connectionError)
                }
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = false
        setupScrollView()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    private func setupScrollView() {
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
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
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = self?.viewModel?.imgData,
                let mimeType = self?.viewModel?.mimeType,
                let fileName = self?.viewModel?.imageModel.title {
                composeVC.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
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
        
        coder.encode(viewModel, forKey: DetailViewController.restoreViewModel)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        guard let decodedViewModel = coder.decodeObject(forKey: DetailViewController.restoreViewModel) as? DetailViewModel else { fatalError("An Image did not exist.") }
        
        viewModel = decodedViewModel
    }
    
}
