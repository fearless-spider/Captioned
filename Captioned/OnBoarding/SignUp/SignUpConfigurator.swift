//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SignUpConfigurator {

    func configure(signUpViewController: SignUpViewController)

}

class SignUpConfiguratorImplementation: SignUpViewController {

    func configure(signUpViewController: SignUpViewController) {

        let router = SignUpViewRouterImplementation(signUpViewController: signUpViewController)

        let presenter = SignUpPresenterImplementation(view: signUpViewController, router: router)

        signUpViewController.presenter = presenter

    }
}
