//
//  CommentsPresenter.swift
//  Captioned
//
//  Created by Przemysław Pająk on 21.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol CommentsView: class {
    
}

protocol CommentsPresenter {
    
    var router: CommentsViewRouter { get }
    
}

class CommentsPresenterImplementation: CommentsPresenter {
    
    fileprivate weak var view: CommentsView?
    let router: CommentsViewRouter
    
    init(view: CommentsView, router: CommentsViewRouter) {
        
        self.view = view
        self.router = router
        
    }
    
}
