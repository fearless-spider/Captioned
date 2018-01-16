//
//  RootBadge.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit

public class RootBadge: UILabel {
    
    var topConstraint: NSLayoutConstraint?
    var centerXConstraint: NSLayoutConstraint?
    var numberLabel: UILabel?
    
    class func bage()->RootBadge {
        return RootBadge.init(frame: CGRect(x:0, y:0, width:18, height:18))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.red.cgColor;
        self.layer.cornerRadius = frame.size.width / 2;
        
        configureNumberLabel()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        createSizeConstraints(size: frame.size)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // PRAGMA: create
    
    func createSizeConstraints(size: CGSize) {
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.greaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: size.width)
        self.addConstraint(widthConstraint)
        
        
        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: size.height)
        self.addConstraint(heightConstraint)
    }
    
    func configureNumberLabel()  {
        
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = UIColor.white
    }
    
    // PRAGMA: helpers
    
    func addBadgeOnView(onView:UIView) {
        
        onView.addSubview(self)
        
        // create constraints
        topConstraint = NSLayoutConstraint(item: self,
                                           attribute: NSLayoutAttribute.top,
                                           relatedBy: NSLayoutRelation.equal,
                                           toItem: onView,
                                           attribute: NSLayoutAttribute.top,
                                           multiplier: 1,
                                           constant: 3)
        onView.addConstraint(topConstraint!)
        
        centerXConstraint = NSLayoutConstraint(item: self,
                                               attribute: NSLayoutAttribute.centerX,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: onView,
                                               attribute: NSLayoutAttribute.centerX,
                                               multiplier: 1,
                                               constant: 10)
        onView.addConstraint(centerXConstraint!)
    }
}

