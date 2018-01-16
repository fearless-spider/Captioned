//
//  AppEnvironment.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation

public class AppEnvironment {
    public enum Application: String {
        case Captioned = "Captioned"
        case SocialNetwork = "Mems"
    }
    
    public class func application() -> Application {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "APP_NAME") as? String {
            return Application(rawValue: appName) ?? .Captioned
        }
        
        return .Captioned
    }
}
