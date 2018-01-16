//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol HomeConfigurator {

    func configure(homeViewController: HomeViewController)

}

class HomeConfiguratorImplementation: HomeViewController {

    func configure(homeViewController: HomeViewController) {

        let router = HomeViewRouterImplementation(homeViewController: homeViewController)

        let presenter = HomePresenterImplementation(view: homeViewController, router: router)

        homeViewController.presenter = presenter

    }
}
