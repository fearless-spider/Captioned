//
//  AnimeCell.swift
//  AnimeNow
//
//  Created by Paul Chavarria Podoliako on 6/4/15.
//  Copyright (c) 2015 AnyTap. All rights reserved.
//

import UIKit


class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let posterImageView = posterImageView {
            posterImageView.layer.shadowColor = UIColor.init(red: 48/255.0, green: 50/255.0, blue: 60/255.0, alpha: 1.0).cgColor
            posterImageView.layer.shadowOffset = CGSize.zero
            posterImageView.layer.shadowOpacity = 1
        }
    }
    
}

// MARK: - Layout
extension PostCell {
    class func updateLayoutItemSizeWithLayout(layout: UICollectionViewFlowLayout, viewSize: CGSize) {
        let margin: CGFloat = 1
        let columns: CGFloat = UIDevice.isLandscape() ? 2 : 2
        let cellHeight: CGFloat = 160
        var cellWidth: CGFloat = 160
        
        layout.minimumLineSpacing = margin
        
        if UIDevice.isPad() {
            layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
            let totalWidth: CGFloat = viewSize.width - (margin * (columns + 1))
            cellWidth = totalWidth / columns
            layout.minimumInteritemSpacing = margin
            layout.minimumLineSpacing = margin
        } else {
            layout.sectionInset = UIEdgeInsets.zero
            cellWidth = viewSize.width
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
        }
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
