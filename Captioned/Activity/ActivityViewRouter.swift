//
//  ActivityViewRouter.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol ActivityViewRouter: ViewRouter {
    
}

class ActivityViewRouterImplementation: ActivityViewRouter {
    
    fileprivate weak var activityViewController: ActivityViewController?
    
    init(activityViewController: ActivityViewController) {
        
        self.activityViewController = activityViewController
        
    }
    
}
