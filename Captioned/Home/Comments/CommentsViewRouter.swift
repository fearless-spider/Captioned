//
//  CommentsViewRouter.swift
//  Captioned
//
//  Created by Przemysław Pająk on 21.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

protocol CommentsViewRouter: ViewRouter {
    
}

class CommentsViewRouterImplementation: CommentsViewRouter {
    
    fileprivate weak var commentsViewController: CommentsViewController?
    
    init(commentsViewController: CommentsViewController) {
        
        self.commentsViewController = commentsViewController
        
    }
    
}
