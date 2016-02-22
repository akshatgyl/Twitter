//
//  TweetDetailViewController.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/16/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import CSStickyHeaderFlowLayout

class TweetDetailViewController: UIViewController {

    
    var tweet: Tweet?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweet: UILabel!
    @IBOutlet weak var favorite: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = tweet?.user
        
        userNameLabel.text = user?.name
        userImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
        userScreenNameLabel.text = "@\((user?.screenName)!)"
        tweetLabel.text = tweet!.text
        
        userImageView.layer.cornerRadius = 10
        userImageView.clipsToBounds = true
        
        let time = Int((tweet!.createdAt?.timeIntervalSinceNow)!)
        if (-time/3600) == 0 {
            timeLabel.text = "\(-time/60)m"
        } else {
            timeLabel.text = "\(-time/3600)h"
        }
        
        if tweet!.retweeted! {
            retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            retweetsLabel.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
            retweet.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
            retweetsLabel.text = "\(tweet!.retweetCount!)"
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            retweetsLabel.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
            retweet.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
            retweetsLabel.text = "\(tweet!.retweetCount!)"
        }
        
        if  tweet!.liked! {
            favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            favoritesLabel.textColor = UIColor(red: 238/255.0, green: 22/255.0, blue: 79/255.0, alpha: 1)
            favoritesLabel.text = "\(tweet!.likeCount!)"
        } else {
            favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            favoritesLabel.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
            favoritesLabel.text = "\(tweet!.likeCount!)"
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetInDetailView(sender: AnyObject) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.unretweet((tweet?.id)!, completion: { (response, error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
                self.tweet!.retweetCount = (self.tweet?.retweetCount?.integerValue)! - 1
                self.tweet?.retweeted = false
                self.retweetsLabel.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
                self.retweet.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
                self.retweetsLabel.text = "\((self.tweet?.retweetCount!)!)"
            })
            
        } else {
            TwitterClient.sharedInstance.retweet((tweet?.id)!) { (response, error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
                self.tweet?.retweetCount = (self.tweet?.retweetCount?.integerValue)! + 1
                self.tweet?.retweeted = true
                self.retweetsLabel.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
                self.retweet.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
                self.retweetsLabel.text = "\((self.tweet?.retweetCount!)!)"
            }
        }
        
    }
    
    @IBAction func onLike(sender: AnyObject) {
        if tweet!.liked! {
            TwitterClient.sharedInstance.unLike((tweet?.id)!, completion: { (response, error) -> () in
                self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue - 1
                self.tweet!.liked = false
                self.favoritesLabel.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
                self.favorite.textColor = UIColor(red: 58/255.0, green: 71/255.0, blue: 80/255.0, alpha: 1)
                self.favoritesLabel.text = "\((self.tweet?.likeCount!)!)"
            })
            
        } else {
            TwitterClient.sharedInstance.like((tweet?.id)!) { (response, error) -> () in
                self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                self.tweet?.likeCount = (self.tweet?.likeCount?.integerValue)! + 1
                self.tweet!.liked = true
                self.favoritesLabel.textColor = UIColor(red: 238/255.0, green: 22/255.0, blue: 79/255.0, alpha: 1)
                self.favorite.textColor = UIColor(red: 238/255.0, green: 22/255.0, blue: 79/255.0, alpha: 1)
                self.favoritesLabel.text = "\((self.tweet?.likeCount!)!)"
            }
        }
    }
    
    @IBAction func onTapProfileImage(sender: AnyObject) {
        performSegueWithIdentifier("displayProfile1", sender: self)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "displayProfile1") {
            let vc = segue.destinationViewController as! ProfileViewController
            vc.tweet = tweet
        }
        
    }

    
    
    
    
    
    

}
