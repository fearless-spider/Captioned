//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol HomeView: class {

}

protocol HomePresenter {

    var router: HomeViewRouter { get }

}

class HomePresenterImplementation: HomePresenter {

    fileprivate weak var view: HomeView?
    let router: HomeViewRouter

    init(view: HomeView, router: HomeViewRouter) {

        self.view = view
        self.router = router

    }

}