//
//  CustomTextField.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Motion
import Material

public class CustomTextField: ErrorTextField {
    
    @IBOutlet var nextField : ErrorTextField?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: bounds.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
}

public extension CustomTextField {
    
    func isEmpty() -> Bool {
        return text!.characters.count == 0
    }
    
    func validEmail() -> Bool {
        let emailRegex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let regularExpression = try? NSRegularExpression(pattern: emailRegex, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regularExpression?.numberOfMatches(in: text!, options: [], range: NSMakeRange(0, (text! as NSString).length))
        return (matches == 1)
    }
    
    func hasEqualTextAs(otherTextField:UITextField) -> Bool {
        return (text == otherTextField.text)
    }
    
    func validPassword() -> Bool {
        return text!.characters.count >= 6
    }
    
    func trimSpaces() {
        text = text!.replacingOccurrences(of: " ", with: "")
    }
    
}
