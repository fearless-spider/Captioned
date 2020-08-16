//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol FavoritesConfigurator {
    
    func configure(favoritesViewController: FavoritesViewController)
    
}

class FavoritesConfiguratorImplementation: FavoritesViewController {
    
    func configure(favoritesViewController: FavoritesViewController) {
        
        let router = FavoritesViewRouterImplementation(favoritesViewController: favoritesViewController)
        
        let presenter = FavoritesPresenterImplementation(view: favoritesViewController, router: router)
        
        favoritesViewController.presenter = presenter
        
    }
}
