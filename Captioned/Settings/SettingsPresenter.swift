//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol SettingsView: class {
    
}

protocol SettingsPresenter {
    
    var router: SettingsViewRouter { get }
    
}

class SettingsPresenterImplementation: SettingsPresenter {
    
    fileprivate weak var view: SettingsView?
    let router: SettingsViewRouter
    
    init(view: SettingsView, router: SettingsViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}
