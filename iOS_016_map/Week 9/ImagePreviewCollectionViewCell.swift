//
//  ImagePreviewCollectionViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 22/04/24.
//

import UIKit

class ImagePreviewCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
        
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
    }
    
    @objc func doubleTapped(_ sender: UITapGestureRecognizer) {
        //self.imageView.transform = self.imageView.transform.scaledBy(x: 2, y: 2)
        
        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(2, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}


