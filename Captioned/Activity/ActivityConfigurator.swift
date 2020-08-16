//
//  ActivityConfigurator.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ActivityConfigurator {
    
    func configure(activityViewController: ActivityViewController)
    
}

class ActivityConfiguratorImplementation: ActivityViewController {
    
    func configure(activityViewController: ActivityViewController) {
        
        let router = ActivityViewRouterImplementation(activityViewController: activityViewController)
        
        let presenter = ActivityPresenterImplementation(view: activityViewController, router: router)
        
        activityViewController.presenter = presenter
        
    }
}
