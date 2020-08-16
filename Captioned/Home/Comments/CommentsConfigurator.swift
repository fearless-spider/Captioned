//
//  CommentsConfigurator.swift
//  Captioned
//
//  Created by Przemysław Pająk on 21.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol CommentsConfigurator {
    
    func configure(commentsViewController: CommentsViewController)
    
}

class CommentsConfiguratorImplementation: CommentsViewController {
    
    func configure(commentsViewController: CommentsViewController) {
        
        let router = CommentsViewRouterImplementation(commentsViewController: commentsViewController)
        
        let presenter = CommentsPresenterImplementation(view: commentsViewController, router: router)
        
        commentsViewController.presenter = presenter
        
    }
}
