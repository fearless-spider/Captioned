//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol FavoritesViewRouter: ViewRouter {
    
}

class FavoritesViewRouterImplementation: FavoritesViewRouter {
    
    fileprivate weak var favoritesViewController: FavoritesViewController?
    
    init(favoritesViewController: FavoritesViewController) {
        
        self.favoritesViewController = favoritesViewController
        
    }
    
}
