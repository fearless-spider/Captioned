//
//  ActivityPresenter.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol ActivityView: class {
    
}

protocol ActivityPresenter {
    
    var router: ActivityViewRouter { get }
    
}

class ActivityPresenterImplementation: ActivityPresenter {
    
    fileprivate weak var view: ActivityView?
    let router: ActivityViewRouter
    
    init(view: ActivityView, router: ActivityViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}
