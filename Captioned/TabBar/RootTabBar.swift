//
//  RootTabBar.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import ColorWithHex
import Material

extension RootTabBarItem {
    
    override public var badgeValue: String? {
        get {
            return badge?.text
        }
        set(newValue) {
            
            if newValue == nil {
                badge?.removeFromSuperview()
                badge = nil;
                return
            }
            
            if badge == nil {
                badge = RootBadge.bage()
                if let contanerView = self.iconView!.icon.superview {
                    badge!.addBadgeOnView(onView: contanerView)
                }
            }
            
            badge?.text = newValue
        }
    }
}


public class RootTabBarItem: UITabBarItem {
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 10)
    @IBInspectable public var textColor: UIColor = UIColor.black
    @IBInspectable public var iconColor: UIColor = UIColor.black // if alpha color is 0 color ignoring
    
    @IBInspectable var bgDefaultColor: UIColor = UIColor.white // background color
    @IBInspectable var bgSelectedColor: UIColor = UIColor.white
    @IBInspectable var highlight: Bool = false
    
    public var badge: RootBadge? // use badgeValue to show badge
    
    public var iconView: (icon: UIImageView, textLabel: UILabel)?
}

extension RootTabBar {
    
    public func changeSelectedColor(textSelectedColor:UIColor, iconSelectedColor:UIColor) {
        
        let items = tabBar.items as! [RootTabBarItem]
        for index in 0..<items.count {
            let item = items[index]
            
            if item == self.tabBar.selectedItem {
                //item.selectedState()
            }
        }
    }
    
    public func animationTabBarHidden(isHidden:Bool) {
        guard let items = tabBar.items as? [RootTabBarItem] else {
            fatalError("items must inherit RootTabBarItem")
        }
        for item in items {
            if let iconView = item.iconView {
                iconView.icon.superview?.isHidden = isHidden
            }
        }
        self.tabBar.isHidden = isHidden;
    }
    
    public func setSelectIndex(from: Int, to: Int) {
        selectedIndex = to
        guard let items = tabBar.items as? [RootTabBarItem] else {
            fatalError("items must inherit RootTabBarItem")
        }
        
        let containerFrom = items[from].iconView?.icon.superview
        containerFrom?.backgroundColor = items[from].bgDefaultColor
        items[from].iconView?.icon.tintColor = UIColor.black
        
        let containerTo = items[to].iconView?.icon.superview
        containerTo?.backgroundColor = items[to].bgSelectedColor
        items[to].iconView?.icon.tintColor = UIColor.colorWithHex("2196F3")!
    }
}

public class RootTabBar: UITabBarController {
    public static let ShowedLoginDefault = "Defaults.ShowedLogin"
    
    var selectedDefaultTabOnce = false
    var chechedForNotificationsOnce = false
    
    private var didInit: Bool = false
    private var didLoadView: Bool = false
    
    
    /*    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
     super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     
     self.didInit = true
     self.initializeContainers()
     }*/
    
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        self.didInit = true
        
        // Set initial items
        self.setViewControllers(viewControllers, animated: false)
        
        self.initializeContainers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.didInit = true
        self.initializeContainers()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        self.didLoadView = true
        
        self.initializeContainers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !selectedDefaultTabOnce {
            selectedDefaultTabOnce = true
            if let value = UserDefaults.standard.value(forKey: DefaultLoadingScreen) as? String {
                switch value {
                case "Search":
                    selectedIndex = 1
                default:
                    break
                }
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initializeContainers() {
        if !self.didInit || !self.didLoadView {
            return
        }
        
        let containers = self.createViewContainers()
        
        self.createCustomIcons(containers: containers)
    }
    
    // MARK: create methods
    
    private func createCustomIcons(containers : NSDictionary) {
        
        guard let items = self.tabBar.items as? [RootTabBarItem] else {
            fatalError("items must inherit RootTabBarItem")
        }
        
        var index = 0
        for item in items {
            
            guard let itemImage = item.image else {
                fatalError("add image icon in UITabBarItem")
            }
            
            guard let container = containers["container\(items.count - 1 - index)"] as? UIView else {
                fatalError()
            }
            container.tag = index
            
            
            let renderMode = UIImageRenderingMode.alwaysTemplate
            
            let icon = UIImageView(image: item.image?.withRenderingMode(renderMode))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = item.iconColor
            
            // text
            let textLabel = UILabel()
            textLabel.isHidden = true
            /*            textLabel.text = item.title
             textLabel.backgroundColor = UIColor.clearColor()
             textLabel.textColor = item.textColor
             textLabel.font = item.textFont
             textLabel.textAlignment = NSTextAlignment.Center
             textLabel.translatesAutoresizingMaskIntoConstraints = false
             */
            container.backgroundColor = (items as [RootTabBarItem])[index].bgDefaultColor
            
            container.addSubview(icon)
            createConstraints(view: icon, container: container, size: itemImage.size, yOffset: 0)
            
            //container.addSubview(textLabel)
            //let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
            //createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
            
            item.iconView = (icon:icon, textLabel:textLabel)
            
            if 0 == index { // selected first elemet
                //item.selectedState()
                container.backgroundColor = (items as [RootTabBarItem])[index].bgSelectedColor
                let border = UIView()
                border.frame = CGRect(x:0, y:icon.frame.height+2, width:icon.frame.width+10, height:2)
                border.backgroundColor = UIColor.colorWithHex("2196F3")!
                container.addSubview(border)
                container.bringSubview(toFront: border)
                icon.tintColor = UIColor.colorWithHex("2196F3")!
            }
            
            item.image = nil
            item.title = ""
            index += 1
        }
    }
    
    private func createConstraints(view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        let constX = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerX,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerX,
                                        multiplier: 1,
                                        constant: 0)
        container.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerY,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerY,
                                        multiplier: 1,
                                        constant: yOffset)
        container.addConstraint(constY)
        
        let constW = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.width,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: size.width)
        view.addConstraint(constW)
        
        let constH = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.height,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: size.height)
        view.addConstraint(constH)
    }
    
    private func createViewContainers() -> NSDictionary {
        
        guard let items = self.tabBar.items else {
            fatalError("add items in tabBar")
        }
        
        var containersDict = [String: AnyObject]()
        
        for index in 0..<items.count {
            let viewContainer = createViewContainer()
            containersDict["container\(index)"] = viewContainer
        }
        
        var formatString = "H:|-(0)-[container0]"
        for index in 1..<items.count {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let  constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                           options:NSLayoutFormatOptions.directionRightToLeft,
                                                                           metrics: nil,
                                                                           views: (containersDict as [String : AnyObject]))
        view.addConstraints(constranints)
        
        return containersDict as NSDictionary
    }
    
    private func createViewContainer() -> UIView {
        let viewContainer = UIView();
        viewContainer.backgroundColor = UIColor.clear // for test
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RootTabBar.tapHandler(gesture:)))
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        
        // add constrains
        let constY = NSLayoutConstraint(item: viewContainer,
                                        attribute: NSLayoutAttribute.bottom,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: view,
                                        attribute: NSLayoutAttribute.bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        view.addConstraint(constY)
        
        let constH = NSLayoutConstraint(item: viewContainer,
                                        attribute: NSLayoutAttribute.height,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: tabBar.frame.size.height)
        viewContainer.addConstraint(constH)
        
        return viewContainer
    }
    
    // MARK: actions
    
    @objc func tapHandler(gesture:UIGestureRecognizer) {
        
        guard let items = tabBar.items as? [RootTabBarItem] else {
            fatalError("items must inherit RootTabBarItem")
        }
        
        guard let gestureView = gesture.view else {
            return
        }
        
        let currentIndex = gestureView.tag
        
        let controller = self.childViewControllers[currentIndex]
        
        if let shouldSelect = delegate?.tabBarController?(self, shouldSelect: controller), !shouldSelect {
            return
        }
        
        if selectedIndex != currentIndex {
            let animationItem : RootTabBarItem = items[currentIndex]
            
            let deselectItem = items[selectedIndex]
            
            let containerPrevious : UIView = deselectItem.iconView!.icon.superview!
            //containerPrevious.backgroundColor = items[currentIndex].bgDefaultColor
            let borderPrevious = UIView()
            borderPrevious.frame = CGRect(x:0, y:containerPrevious.frame.height - 2, width:containerPrevious.frame.width, height:2)
            if (!deselectItem.highlight) {
                borderPrevious.backgroundColor = UIColor.white
                deselectItem.iconView!.icon.tintColor = UIColor.black
            } else {
                borderPrevious.backgroundColor = UIColor.colorWithHex("2196F3")!
                deselectItem.iconView!.icon.tintColor = UIColor.white
            }
            containerPrevious.addSubview(borderPrevious)
            
            let container : UIView = animationItem.iconView!.icon.superview!
            //container.backgroundColor = items[currentIndex].bgSelectedColor
            let border = UIView()
            border.frame = CGRect(x:0, y:container.frame.height - 2, width:container.frame.width, height:2)
            border.backgroundColor = UIColor.colorWithHex("2196F3")!
            container.addSubview(border)
            if (!animationItem.highlight) {
                animationItem.iconView!.icon.tintColor = UIColor.colorWithHex("2196F3")!
            } else {
                animationItem.iconView!.icon.tintColor = UIColor.white
            }
            selectedIndex = gestureView.tag
            delegate?.tabBarController?(self, didSelect: controller)
        } else if selectedIndex == currentIndex {
            
            if let navVC = self.viewControllers![selectedIndex] as? UINavigationController {
                navVC.popToRootViewController(animated: true)
            }
        }
    }
}

extension RootTabBar: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        _ = viewController as! UINavigationController
        
        return true
    }
}
