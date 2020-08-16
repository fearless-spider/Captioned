//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SearchViewRouter: ViewRouter {
    
}

class SearchViewRouterImplementation: SearchViewRouter {
    
    fileprivate weak var searchViewController: SearchViewController?
    
    init(searchViewController: SearchViewController) {
        
        self.searchViewController = searchViewController
        
    }
    
}
