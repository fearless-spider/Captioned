//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol SearchView: class {
    
}

protocol SearchPresenter {
    
    var router: SearchViewRouter { get }
    
}

class SearchPresenterImplementation: SearchPresenter {
    
    fileprivate weak var view: SearchView?
    let router: SearchViewRouter
    
    init(view: SearchView, router: SearchViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}
