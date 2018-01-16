//
//  UICollectionView+Cells.swift
//  Captioned
//
//  Created by Przemysław Pająk on 13.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerNibWithClass(cell: UICollectionViewCell.Type) {
        let className = String(describing: cell)
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCellWithClass<T>(cell: T.Type, indexPath: NSIndexPath) -> T? {
        let className = String(describing: cell)
        return dequeueReusableCell(withReuseIdentifier: className, for: indexPath as IndexPath) as? T
    }
}
