//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol SignInView: class {

}

protocol SignInPresenter {

    var router: SignInViewRouter { get }

}

class SignInPresenterImplementation: SignInPresenter {

    fileprivate weak var view: SignInView?
    let router: SignInViewRouter

    init(view: SignInView, router: SignInViewRouter) {

        self.view = view
        self.router = router

    }

}
