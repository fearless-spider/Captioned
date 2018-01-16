//
//  Captioned.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import Crashlytics

public struct Captioned {
    static let DEBUG = true
    
    static var domain: String {
        if Captioned.DEBUG {
            // DEV
            return "http://127.0.0.1:8000"
        } else {
            // LIVE
            return "http://www.captionedapp.com"
        }
    }
    static var OAuthToken: String?
    static var OAuthBearerToken: String?
    static var OAuthRefreshToken: String?
    static var user: User!
    
    public enum Router: URLRequestConvertible {
        
        static let BaseURLString = Captioned.domain + "/api"
        
        case users()
        case follow(id: Int)
        case unfollow(id: Int)
        case profile()
        case token(username: String, password: String)
        case create(username: String, email: String, password: String, fileContents: NSData)
        case update(first_name: String, last_name: String, fileContents: NSData)
        case postList()
        case userPostList(user_id: Int)
        case searchList(term: String)
        case favoriteList()
        case trendingList()
        case competitionList()
        case upload(fileContents: NSData, content: String, hashtags: String)
        case commentList(id: String)
        case comment(id: String, content: String)
        case like(id: String)
        case resetPassword(email: String)
        case facebookConnect(token: String)
        case actions()
        case actionYou()
        case logout()
        case delete()
        case updateNotifications(favorites: Bool)
        case setAPN(registration_id: String, cloud_message_type: String, active: Int)

        public func asURLRequest() throws -> URLRequest {
            let (method, path, parameters, builder, multipart): (Alamofire.HTTPMethod, String, [String: AnyObject], MultipartDataBuilder, Bool) = {
                switch self {
                case .users():
                    return (.get, "users/", [:], MultipartDataBuilder(), false)
                case .follow(let id):
                    return (.post, "follows/", ["user_id":id as AnyObject], MultipartDataBuilder(), false)
                case .unfollow(let id):
                    return (.delete, "follows/\(id)/", [:], MultipartDataBuilder(), false)
                case .profile():
                    return (.get, "profile/", [:], MultipartDataBuilder(), false)
                case .token(let username, let password):
                    return (.post, "auth/token/", ["username":username as AnyObject, "password":password as AnyObject], MultipartDataBuilder(), false)
                case .create(let username, let email, let password, let fileContents):
                    var builder = MultipartDataBuilder()
                    builder.appendFormData(name: "avatar", content: fileContents, fileName: "avatar.jpg", contentType: "image/jpeg")
                    builder.appendFormData(key: "username", value: username)
                    builder.appendFormData(key: "email", value: email)
                    builder.appendFormData(key: "password", value: password)
                    return (.post, "users/", [:], builder, true)
                case .update(let first_name, let last_name, let fileContents):
                    var builder = MultipartDataBuilder()
                    builder.appendFormData(name: "avatar", content: fileContents, fileName: "avatar.jpg", contentType: "image/jpeg")
                    builder.appendFormData(key: "first_name", value: first_name)
                    builder.appendFormData(key: "last_name", value: last_name)
                    return (.put, "profile/\(Captioned.user.userID())/update/", [:], builder, true)
                case .postList():
                    return (.get, "posts/", [:], MultipartDataBuilder(), false)
                case .userPostList(let user_id):
                    return (.get, "posts/", ["user__id":user_id as AnyObject], MultipartDataBuilder(), false)
                case .searchList(let term):
                    return (.get, "posts/", ["search":term as AnyObject], MultipartDataBuilder(), false)
                case .favoriteList():
                    return (.get, "favorite/posts/", [:], MultipartDataBuilder(), false)
                case .trendingList():
                    return (.get, "trending/posts/", [:], MultipartDataBuilder(), false)
                case .competitionList():
                    return (.get, "competition/posts/", [:], MultipartDataBuilder(), false)
                case .upload(let fileContents, let content, let hashtags):
                    var builder = MultipartDataBuilder()
                    builder.appendFormData(name: "photo", content: fileContents, fileName: "photo.jpg", contentType: "image/jpeg")
                    builder.appendFormData(key: "caption", value: content)
                    builder.appendFormData(key: "hashtags", value: hashtags)
                    return (.post, "posts/", [:], builder, true)
                case .commentList(let id):
                    return (.get, "comments/", ["post__id":id as AnyObject], MultipartDataBuilder(), false)
                case .comment(let post_id, let content):
                    return (.post, "comments/", ["post_id":post_id as AnyObject, "content":content as AnyObject], MultipartDataBuilder(), false)
                case .like(let post_id):
                    return (.post, "likes/", ["receiver_object_id":post_id as AnyObject], MultipartDataBuilder(), false)
                case .resetPassword(let email):
                    return (.post, "password/reset/", ["email":email as AnyObject], MultipartDataBuilder(), false)
                case .facebookConnect(let token):
                    return (.post, "auth/convert-token", ["grant_type":"convert_token" as AnyObject as AnyObject, "client_id":"Ir2TPf5IXJcSKATovBZ9ZwWi8Bf7y80PVnKBgZO9" as AnyObject, "client_secret":"LN3d4hehVvoCLwltsPKD3iIB1Y9DibtO49vQqoWYoIpTtvC6Z3b3RrjppUaxPh2jbhbTjdcPb7WwK1cVpPuxGgzDR54ojnfTd8vY6VzxtyGpENrsuW9XGrPl4xL4pBw6" as AnyObject, "backend":"facebook" as AnyObject, "token":token as AnyObject], MultipartDataBuilder(), false)
                case .actions():
                    return (.post, "actions/", [:], MultipartDataBuilder(), false)
                case .actionYou():
                    return (.get, "action/you/", [:], MultipartDataBuilder(), false)
                case .logout():
                    return (.post, "auth/logout/", ["token":Captioned.OAuthBearerToken as AnyObject], MultipartDataBuilder(), false)
                case .delete():
                    return (.post, "delete/", [:], MultipartDataBuilder(), false)
                case .updateNotifications(let favorites):
                    return (.post, "notifications/", ["favorites": favorites as AnyObject], MultipartDataBuilder(), false)
                case .setAPN(let registration_id, let cloud_message_type, let active):
                    return (.post, "device/gcm/", ["registration_id": registration_id as AnyObject, "cloud_message_type": cloud_message_type as AnyObject, "active": active as AnyObject], MultipartDataBuilder(), false)
                }
            }()
            
            let URL: Foundation.URL = Foundation.URL(string: Router.BaseURLString)!
            var mURLRequest = URLRequest(url: (URL.appendingPathComponent(path)))
            
            if let token = Captioned.OAuthToken {
                mURLRequest.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
            }
            if let token = Captioned.OAuthBearerToken {
                mURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                mURLRequest.setValue("\(version)", forHTTPHeaderField: "TagLife-Version")
            }
            if (multipart) {
                mURLRequest.setValue("multipart/form-data; boundary=\(builder.boundary)", forHTTPHeaderField: "Content-Type")
                mURLRequest.httpBody = builder.build()! as Data
            }
            mURLRequest.httpMethod = method.rawValue
            mURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            return try URLEncoding.default.encode(mURLRequest, with: parameters.count > 0 ? parameters : nil)
        }
    }
    
    public static func currentUserLoggedIn() -> Bool {
        return self.OAuthToken != nil
    }
    
    public static func logOutInBackground() -> Void {
        Alamofire.request(Captioned.Router.logout()).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                deleteTokens()
            case .failure(let error):
                Crashlytics.sharedInstance().recordError(error)
                
                deleteTokens()
                print("Request failed with error: \(error)")
            }
        }
    }
    
    public static func saveTokens(access_token: String, refresh_token: String) {
        let defaults = UserDefaults.standard
        self.OAuthBearerToken = access_token
        self.OAuthRefreshToken = refresh_token
        defaults.setValue(access_token, forKey: "access_token")
        defaults.setValue(refresh_token, forKey: "refresh_token")
        defaults.synchronize()
    }
    
    public static func loadTokens() {
        let defaults = UserDefaults.standard
        self.OAuthBearerToken = defaults.string(forKey: "access_token")
        self.OAuthRefreshToken = defaults.string(forKey: "refresh_token")
    }
    
    public static func deleteTokens() {
        let defaults = UserDefaults.standard
        self.OAuthBearerToken = nil
        self.OAuthRefreshToken = nil
        defaults.removeObject(forKey: "instagramtoken")
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "refresh_token")
        defaults.synchronize()
        if (FBSDKAccessToken.current() != nil) {
            FBSDKLoginManager().logOut()
        }
    }
    
}

