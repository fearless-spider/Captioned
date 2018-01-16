//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SignInViewRouter: ViewRouter {

}

class SignInViewRouterImplementation: SignInViewRouter {

    fileprivate weak var signInViewController: SignInViewController?

    init(signInViewController: SignInViewController) {

        self.signInViewController = signInViewController

    }

}

