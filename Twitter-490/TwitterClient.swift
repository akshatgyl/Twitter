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

var loginCompletion: ((user: User?, error: NSError?) -> ())?


class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        
        //fetch my request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got the equest token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            //self.loginWithCompletion(user: nil, error: error)
            print("failed to get request token")
        }
    }
    
        
        func openURL(url: NSURL) {
            
            
           fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    //print("user:\(response)")
                    var user = User(dictionary: response as! NSDictionary)
                    print("user: \(user.name)")
                    TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        //print("home_timeline:\(response)")
                        var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                        
                        for tweet in tweets {
                            print("text: \(tweet.text), created: \(tweet.createdAt)")
                        }
                        
                        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                            print("error getting home_timeline")
                    })
                    
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("error getting current user")
                })
                }) { (error: NSError!) -> Void in
                    print("failed to recieve access token")
                    //self.loginWithCompletion?(user: nil, error: error)
            }
    }
}



