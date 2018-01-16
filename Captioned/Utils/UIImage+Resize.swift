//
//  UIImage+Resize.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit

extension UIImage {
    public class func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    
    // Only works for squares
    public class func imageWithImage(image: UIImage, maxSize: CGSize) -> UIImage {
        
        let imageWidth = image.size.width > maxSize.width ? maxSize.width : image.size.width
        let imageHeight = image.size.height > maxSize.height ? maxSize.height : image.size.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 1.0);
        
        image.draw(in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!
    }
}
