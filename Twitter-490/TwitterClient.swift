//
//  TwitterClien.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/8/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "5GCekZZ8XOozM2Z4S116zaYsu"
let twitterConsumerSecret = "IvFYuA4LMkqo0pXVzepFqCnWx9EzraTxjr5hyOV3N5cZExUBmj"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    
}
