//
//  UIImageView+Extensions.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 06/11/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// - Note: To make it works you needs implement additional setups of constraints: scrollViewHeightPriority = low, scrollViewWidthPriority = low, containerView: bottom >= scrollView.bottom; scrollView.top >= top; centerX = scrollView.centerX; centerY = scrollView.centerY; trailing >= scrollView.trailing; scrollView.leading >= leading. Make outlets of your scrollView, scrollViewHeight, scrollViewWidth, containerView and then just add your imageView to scrollView as a subView. Implement UIScrollViewDelegate: viewForZooming = imageView; scrollViewDidZoom { scrollSize = scrollView.contentSize }
    func setupOnScrollView(_ scrollView: UIScrollView?, height: NSLayoutConstraint?, width: NSLayoutConstraint?, image: UIImage?, in containerView: UIView?) {
        
        scrollView?.addSubview(self)
        scrollView?.zoomScale = 1.0
        
        self.image = image
        
        let size = image?.size ?? CGSize.zero
        self.frame = CGRect(origin: CGPoint.zero, size: size)
        
        scrollView?.contentSize = size
        height?.constant = size.height
        width?.constant = size.width
        
        guard let containerView = containerView, size.width > 0, size.height > 0 else { return }
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
                        scrollView?.zoomScale = min(2*containerView.bounds.size.width / size.width,
                                                    2*self.bounds.size.height / size.height)
        })
    }
    
}
