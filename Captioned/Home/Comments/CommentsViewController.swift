//
//  CommentsViewController.swift
//  Captioned
//
//  Created by Przemysław Pająk on 14.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SVPullToRefresh
import MHPrettyDate
import ColorWithHex

class CommentsViewController: UIViewController, CommentsView {

    var presenter: CommentsPresenter?
    var configurator = CommentsConfiguratorImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(commentsViewController: self)

    }
    
}
