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

public final class Comment: Mappable {
    var id: Int?
    var comment_date: String?
    var content: String?
    var user_data: [String: AnyObject]?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        comment_date <- map["comment_date"]
        content <- map["content"]
        user_data <- map["user"]
    }
    
    public func postDate() -> NSDate! {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        let dateRecorded: NSDate = formatter.date(from: self.comment_date!)! as NSDate
        return dateRecorded
    }
    
    public func commentID() -> String! {
        return self.id?.description
    }
    public func text() -> String! {
        return self.content
    }
    
    public func from() -> User! {
        return User(JSON:self.user_data!)
    }
}
