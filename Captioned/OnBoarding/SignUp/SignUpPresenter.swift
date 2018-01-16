//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol SignUpView: class {

}

protocol SignUpPresenter {

    var router: SignUpViewRouter { get }

}

class SignUpPresenterImplementation: SignUpPresenter {

    fileprivate weak var view: SignUpView?
    let router: SignUpViewRouter

    init(view: SignUpView, router: SignUpViewRouter) {

        self.view = view
        self.router = router

    }

}
