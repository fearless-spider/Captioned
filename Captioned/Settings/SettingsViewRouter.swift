//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol SettingsViewRouter: ViewRouter {
    
}

class SettingsViewRouterImplementation: SettingsViewRouter {
    
    fileprivate weak var settingsViewController: SettingsViewController?
    
    init(settingsViewController: SettingsViewController) {
        
        self.settingsViewController = settingsViewController
        
    }
    
}
