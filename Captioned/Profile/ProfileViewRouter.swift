//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ProfileViewRouter: ViewRouter {
    
}

class ProfileViewRouterImplementation: ProfileViewRouter {
    
    fileprivate weak var profileViewController: ProfileViewController?
    
    init(profileViewController: ProfileViewController) {
        
        self.profileViewController = profileViewController
        
    }
    
}
