//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SignInConfigurator {

    func configure(signInViewController: SignInViewController)

}

class SignInConfiguratorImplementation: SignInViewController {

    func configure(signInViewController: SignInViewController) {

        let router = SignInViewRouterImplementation(signInViewController: signInViewController)

        let presenter = SignInPresenterImplementation(view: signInViewController, router: router)

        signInViewController.presenter = presenter

    }
}

