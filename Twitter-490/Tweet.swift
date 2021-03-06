//
//  Tweet.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/9/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id: String?
    var retweetCount: NSNumber?
    var likeCount: NSNumber?
    var retweeted: Bool?
    var liked: Bool?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
        retweetCount = dictionary["retweet_count"] as? NSNumber
        likeCount = dictionary["favorite_count"] as? NSNumber
        retweeted = dictionary["retweeted"] as? Bool
        liked = dictionary["favorited"] as? Bool
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    
}
