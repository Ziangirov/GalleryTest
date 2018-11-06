//
//  BaseTableViewController.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 01/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    private static let nibName = "TableCell"
    
    var filteredImages = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCell.reuseID)
    }
 
    func configureCell(_ cell: UITableViewCell, forImage image: Image?) {
        guard let cell = cell as? TableCell else { return }
        guard let imageModel = image, let url = imageModel.tnURL else { return }
        
        cell.textLabel?.text = imageModel.title
        
        cell.imageFetcher = ImageFetcher(withImageURL: url) { image in
            DispatchQueue.main.async {
                guard let text = cell.textLabel?.text, text == imageModel.title else { return }
                
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
}
