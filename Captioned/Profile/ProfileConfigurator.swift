//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ProfileConfigurator {
    
    func configure(profileViewController: ProfileViewController)
    
}

class ProfileConfiguratorImplementation: ProfileViewController {
    
    func configure(profileViewController: ProfileViewController) {
        
        let router = ProfileViewRouterImplementation(profileViewController: profileViewController)
        
        let presenter = ProfilePresenterImplementation(view: profileViewController, router: router)
        
        profileViewController.presenter = presenter
        
    }
}

