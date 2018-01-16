//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol HomeViewRouter: ViewRouter {

}

class HomeViewRouterImplementation: HomeViewRouter {

    fileprivate weak var homeViewController: HomeViewController?

    init(homeViewController: HomeViewController) {

        self.homeViewController = homeViewController

    }

}
