//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ResetPasswordViewRouter: ViewRouter {

}

class ResetPasswordViewRouterImplementation: ResetPasswordViewRouter {

    fileprivate weak var resetPasswordViewController: ResetPasswordViewController?

    init(resetPasswordViewController: ResetPasswordViewController) {

        self.resetPasswordViewController = resetPasswordViewController

    }

}


