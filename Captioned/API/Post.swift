//
//  Post.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public final class Post: Mappable {
    var id: Int?
    var post_date: String?
    var title: String?
    var content: String?
    var photo: String?
    var user_data: [String: AnyObject]?
    var comments_count: Int!
    var likes_count: Int!
    var comments_data: [AnyObject]?
    var likes_data: [String: AnyObject]?
    var liked_data: Bool! = false
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        post_date <- map["post_date"]
        title <- map["caption"]
        photo <- map["photo"]
        user_data <- map["user"]
        comments_count <- map["comments_count"]
        likes_count <- map["likes_count"]
        comments_data <- map["comments"]
        likes_data <- map["likes_data"]
        liked_data <- map["liked"]
    }
    
    public func postID() -> String! {
        return self.id?.description
    }
    
    public func postDate() -> NSDate! {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        let dateRecorded: NSDate = formatter.date(from: self.post_date!)! as NSDate
        return dateRecorded
    }
    
    public func sharedURL() -> NSURL! {
        return NSURL(string: self.photo!)
    }
    
    public func photoURL() -> NSURL! {
        if self.photo != nil {
            if ((self.photo!.contains("http"))) {
                return NSURL(string: self.photo!)
            } else {
                return NSURL(string: Captioned.domain + self.photo!)
            }
        }
        return nil
    }
    
    public func captionText() -> String! {
        return self.title
    }
    
    @available(iOS 2.0, *)
    public func caption() -> [NSObject : AnyObject]! {
        return nil
    }
    
    @available(iOS 2.0, *)
    public func likes() -> [NSObject : AnyObject]! {
        return self.likes_data as! [NSObject : AnyObject]
    }
    
    public func comments() -> [AnyObject]! {
        let commentsArray:NSMutableArray = NSMutableArray()
        for data in self.comments_data! {
            let comment:Comment = Comment(JSON:data as! [String : AnyObject])!
            commentsArray.add(comment)
        }
        return commentsArray as [AnyObject]
    }
    
    public func liked() -> Bool {
        return self.liked_data
    }
    
    public func totalLikes() -> Int {
        return self.likes_count
    }
    
    public func totalComments() -> Int {
        return self.comments_count
    }
    
    public func user() -> User! {
        return User(JSON:self.user_data!)
    }
}
