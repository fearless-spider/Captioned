//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SettingsConfigurator {
    
    func configure(settingsViewController: SettingsViewController)
    
}

class SettingsConfiguratorImplementation: SettingsViewController {
    
    func configure(settingsViewController: SettingsViewController) {
        
        let router = SettingsViewRouterImplementation(settingsViewController: settingsViewController)
        
        let presenter = SettingsPresenterImplementation(view: settingsViewController, router: router)
        
        settingsViewController.presenter = presenter
        
    }
}
