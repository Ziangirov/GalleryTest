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
    
    var imageFetcher: ImageFetcher!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.alpha = 0
        
        imageView?.layer.cornerRadius = 8.0
        imageView?.clipsToBounds = true
        
        textLabel?.textColor = .white
    }    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.alpha = 0
        imageView?.image = nil
        textLabel?.text = nil
    }

}
