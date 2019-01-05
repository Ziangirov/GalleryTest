//
//  TableCell.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 31/10/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class TableCell: UITableViewCell {
    static let reuseID = "cellID"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailTitleLabel: UILabel!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    private var imageFetcher: ImageFetcher!
    
    var imageModel: Image? {
        didSet {
            isLoading = true
            thumbnailTitleLabel?.text = imageModel?.title
            guard let url = imageModel?.tnURL else { return }
            imageFetcher = ImageFetcher(withImageURL: url) { [weak self] image in
                DispatchQueue.main.async {
                    guard let text = self?.thumbnailTitleLabel?.text, text == self?.imageModel?.title else { return }
                    
                    self?.thumbnailImageView?.image = image
                    self?.thumbnailImageView?.appearAnimated()
                    self?.isLoading = false
                    self?.setNeedsLayout()
                }
            }
        }
    }
    
    private var isLoading = true {
        didSet {
            isLoading ? spiner.startAnimating() : spiner.stopAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        isLoading = true
        
        thumbnailImageView?.layer.cornerRadius = 8.0
        thumbnailImageView?.clipsToBounds = true
        thumbnailTitleLabel?.textColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isLoading = true
        thumbnailImageView?.image = nil
        thumbnailTitleLabel?.text = nil
        imageFetcher.cancelLoading()
    }
    
}
