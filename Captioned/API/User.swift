//
//  User.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public final class User: Mappable {
    var id: Int?
    var user_name: String?
    var email: String?
    var first_name: String?
    var last_name: String?
    var avatar: String?
    var followed: Bool! = false
    var followers: Int! = 0
    var posts: Int! = 0
    var favorites: Int! = 0
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        user_name <- map["username"]
        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        avatar <- map["avatar"]
        followed <- map["followed"]
        followers <- map["followers"]
        posts <- map["posts"]
        favorites <- map["favorites"]
    }
    
    public func userID() -> String! {
        return self.id?.description
    }
    
    public func username() -> String! {
        return self.user_name
    }
    
    public func fullname() -> String! {
        if (self.first_name != "" && self.last_name != "") {
            return "@" + self.first_name! + " " + self.last_name!
        } else {
            return "@" + self.user_name!
        }
    }
    
    public func profilePictureURL() -> NSURL! {
        if ((self.avatar) != nil) {
            if ((self.avatar!.contains("http"))) {
                return NSURL(string: self.avatar!)
            } else {
                return NSURL(string: Captioned.domain + self.avatar!)
            }
        } else {
            return nil
        }
    }
    
}
