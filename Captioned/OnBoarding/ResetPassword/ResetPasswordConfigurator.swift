//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ResetPasswordConfigurator {

    func configure(resetPasswordViewController: ResetPasswordViewController)

}

class ResetPasswordConfiguratorImplementation: ResetPasswordViewController {

    func configure(resetPasswordViewController: ResetPasswordViewController) {

        let router = ResetPasswordViewRouterImplementation(resetPasswordViewController: resetPasswordViewController)

        let presenter = ResetPasswordPresenterImplementation(view: resetPasswordViewController, router: router)

        resetPasswordViewController.presenter = presenter

    }
}