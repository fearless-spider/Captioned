//
//  Comment.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public final class Activity: Mappable {
    var activity_date: String?
    var content: String?
    var user_data: [String: AnyObject]?
    var target_data: [String: AnyObject]?
    var target_type: String?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        activity_date <- map["action_date"]
        content <- map["content"]
        user_data <- map["user"]
        target_data <- map["target"]
        target_type <- map["target_type"]
    }
    
    public func postDate() -> NSDate! {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        let dateRecorded: NSDate = formatter.date(from: self.activity_date!)! as NSDate
        return dateRecorded
    }
    
    public func text() -> String! {
        return self.content
    }
    
    public func from() -> User! {
        return User(JSON:self.user_data!)
    }
    
    public func post() -> Post! {
        return Post(JSON:self.target_data!)
    }

    public func user() -> User! {
        return User(JSON:self.target_data!)
    }

}
