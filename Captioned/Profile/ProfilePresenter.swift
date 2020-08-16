//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol ProfileView: class {
    
}

protocol ProfilePresenter {
    
    var router: ProfileViewRouter { get }
    
}

class ProfilePresenterImplementation: ProfilePresenter {
    
    fileprivate weak var view: ProfileView?
    let router: ProfileViewRouter
    
    init(view: ProfileView, router: ProfileViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}
