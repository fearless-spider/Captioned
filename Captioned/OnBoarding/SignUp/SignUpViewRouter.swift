//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SignUpViewRouter: ViewRouter {

}

class SignUpViewRouterImplementation: SignUpViewRouter {

    fileprivate weak var signUpViewController: SignUpViewController?

    init(signUpViewController: SignUpViewController) {

        self.signUpViewController = signUpViewController

    }

}
