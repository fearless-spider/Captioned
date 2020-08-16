//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol FollowersConfigurator {
    
    func configure(followersViewController: FollowersViewController)
    
}

class FollowersConfiguratorImplementation: FollowersViewController {
    
    func configure(followersViewController: FollowersViewController) {
        
        let router = FollowersViewRouterImplementation(followersViewController: followersViewController)
        
        let presenter = FollowersPresenterImplementation(view: followersViewController, router: router)
        
        followersViewController.presenter = presenter
        
    }
}

