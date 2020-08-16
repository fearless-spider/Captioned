//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SearchConfigurator {
    
    func configure(searchViewController: SearchViewController)
    
}

class SearchConfiguratorImplementation: SearchViewController {
    
    func configure(searchViewController: SearchViewController) {
        
        let router = SearchViewRouterImplementation(searchViewController: searchViewController)
        
        let presenter = SearchPresenterImplementation(view: searchViewController, router: router)
        
        searchViewController.presenter = presenter
        
    }
}
