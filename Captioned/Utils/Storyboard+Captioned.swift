//
//  Storyboard+Captioned.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case Onboarding
    case Home
    case Activity
    case Settings
    case Profile
    case Followers
    case Post
    case Search
    
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    private func viewControllerWithClass<T>(className: T.Type) -> T {
        let identifier = String(describing: className)
        return storyboard().instantiateViewController(withIdentifier: identifier) as! T
    }
    
    private func navigationControllerForViewControllerWithClass<T>(className: T.Type) -> UINavigationController {
        let identifier = String(describing: className)
        return storyboard().instantiateViewController(withIdentifier: "\(identifier)Nav") as! UINavigationController
    }
    
    static func followersViewController() -> FollowersViewController {
        return Storyboard.Followers.viewControllerWithClass(className: FollowersViewController.self)
    }
    
    static func favoritesViewController() -> FavoritesViewController {
        return Storyboard.Profile.viewControllerWithClass(className: FavoritesViewController.self)
    }
    
    static func profileViewController() -> ProfileViewController {
        return Storyboard.Profile.viewControllerWithClass(className: ProfileViewController.self)
    }
    
    static func newPostViewController() -> NewPostViewController {
        return Storyboard.Post.viewControllerWithClass(className: NewPostViewController.self)
    }
    
    static func searchViewController() -> SearchViewController {
        return Storyboard.Search.viewControllerWithClass(className: SearchViewController.self)
    }
    
    static func searchViewControllerNav() -> UINavigationController {
        return Storyboard.Search.navigationControllerForViewControllerWithClass(className: SearchViewController.self)
    }
    
    static func commentsViewController() -> CommentsViewController {
        return Storyboard.Home.viewControllerWithClass(className: CommentsViewController.self)
    }
}

