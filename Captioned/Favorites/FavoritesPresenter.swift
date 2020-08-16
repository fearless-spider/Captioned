//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol FavoritesView: class {
    
}

protocol FavoritesPresenter {
    
    var router: FavoritesViewRouter { get }
    
}

class FavoritesPresenterImplementation: FavoritesPresenter {
    
    fileprivate weak var view: FavoritesView?
    let router: FavoritesViewRouter
    
    init(view: FavoritesView, router: FavoritesViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}

