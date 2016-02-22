//
//  User.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/9/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {

    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    var backgroundImageUrl: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        backgroundImageUrl = dictionary["profile_background_image_url"] as? String
        tweetsCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
            let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if let data = data {
            let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        
        }
        
        }
        
        
        
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                
                let data = try! NSJSONSerialization.dataWithJSONObject((user!.dictionary), options: [])
                
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
}







