//
//  DetailViewModel.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 16.11.2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class DetailViewModel {
    enum State {
        case startLoading
        case downloaded
        case finishedOnError
        
        case none
    }
    
    init(withImage image: Image, _ stateHandler: @escaping (State) -> Void) {
        self.imageModel = image
        self.stateHandler = stateHandler
        
        startLoading()
    }
    
    let imageModel: Image
    
    var imgData: Data? { return uiImage?.jpegData(compressionQuality: 1.0) }
    var mimeType: String { return URL.MIMEType.jpeg.rawValue }
    
    private let stateHandler: (State) -> Void
    
    private var imageFetcher: ImageFetcher?
    private(set) var uiImage: UIImage?
    
    private(set) var loadingState: State = .none {
        didSet {
            stateHandler(loadingState)
        }
    }
    
    private func startLoading() {
        if let url = imageModel.imgURL {
            loadingState = .startLoading
            imageFetcher = ImageFetcher(withImageURL: url) { [weak self] in
                if let image = $0 {
                    self?.uiImage = image
                    self?.loadingState = .downloaded
                } else {
                    self?.loadingState = .finishedOnError
                }
            }
        } else {
            loadingState = .finishedOnError
        }
    }
    
}
