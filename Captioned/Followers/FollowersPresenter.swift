//
// Created by Przemysław Pająk on 08.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol FollowersView: class {
    
}

protocol FollowersPresenter {
    
    var router: FollowersViewRouter { get }
    
}

class FollowersPresenterImplementation: FollowersPresenter {
    
    fileprivate weak var view: FollowersView?
    let router: FollowersViewRouter
    
    init(view: FollowersView, router: FollowersViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}

