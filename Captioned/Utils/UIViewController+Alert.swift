//
//  UIViewController+Alert.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit

extension UIViewController {
    public func presentBasicAlertWithTitle(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
