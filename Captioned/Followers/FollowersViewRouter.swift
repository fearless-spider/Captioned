//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol FollowersViewRouter: ViewRouter {
    
}

class FollowersViewRouterImplementation: FollowersViewRouter {
    
    fileprivate weak var followersViewController: FollowersViewController?
    
    init(followersViewController: FollowersViewController) {
        
        self.followersViewController = followersViewController
        
    }
    
}

