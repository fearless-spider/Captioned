//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON

protocol ResetPasswordView: class {

}

protocol ResetPasswordPresenter {

    var router: ResetPasswordViewRouter { get }

}

class ResetPasswordPresenterImplementation: ResetPasswordPresenter {

    fileprivate weak var view: ResetPasswordView?
    let router: ResetPasswordViewRouter

    init(view: ResetPasswordView, router: ResetPasswordViewRouter) {

        self.view = view
        self.router = router

    }

}
