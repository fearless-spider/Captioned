//
//  UIDevice+Utils.swift
//  Captioned
//
//  Created by Przemysław Pająk on 13.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit

extension UIDevice {
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public class func isLandscape() -> Bool {
        return UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
    }
}
