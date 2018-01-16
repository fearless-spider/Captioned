//
//  WorkflowController.swift
//  Captioned
//
//  Created by Przemysław Pająk on 07.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Bolts

class WorkflowController {
    
    class func presentRootTabBar(animated: Bool) {
        
        let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let search = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let post = UIStoryboard(name: "Post", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let activity = UIStoryboard(name: "Activity", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let profile = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let tabBarController = RootTabBar(viewControllers:[home, search, post, activity, profile])
                
        if animated {
            changeRootViewController(vc: tabBarController, animationDuration: 0.5)
        } else {
            if let window = UIApplication.shared.delegate!.window {
                window?.rootViewController = tabBarController
                window?.makeKeyAndVisible()
            }
        }
        
    }
    
    class func presentOnboardingController(asRoot: Bool) {
        
        let onboarding = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! OnboardingViewController
        
        if asRoot {
            onboarding.isInWindowRoot = true
            applicationWindow().rootViewController = onboarding
            applicationWindow().makeKeyAndVisible()
        } else {
            applicationWindow().rootViewController?.present(onboarding, animated: true, completion: nil)
        }
        
    }
    
    class func changeRootViewController(vc: UIViewController, animationDuration: TimeInterval = 0.5) {
        
        var window: UIWindow?
        
        let appDelegate = UIApplication.shared.delegate!
        
        if appDelegate.responds(to: #selector(getter: UIApplicationDelegate.window)) {
            window = appDelegate.window!
        }
        
        if let window = window {
            if window.rootViewController == nil {
                window.rootViewController = vc
                return
            }
            
            let snapshot = window.snapshotView(afterScreenUpdates: true)
            vc.view.addSubview(snapshot!)
            window.rootViewController = vc
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                snapshot?.alpha = 0.0
            }, completion: {(finished) in
                snapshot?.removeFromSuperview()
            })
        }
    }
    
    class func applicationWindow() -> UIWindow {
        return UIApplication.shared.delegate!.window!!
    }
    
    class func logoutUser() -> BFTask<AnyObject> {
        // Remove cookies
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        
        // Logout MAL
        //User.logout()
        
        // Remove defaults
        UserDefaults.standard.removeObject(forKey: RootTabBar.ShowedLoginDefault)
        UserDefaults.standard.synchronize()
        
        // Logout user
        return BFTask()
        
    }
}
