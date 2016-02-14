//
//  TweetCell.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/13/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.unretweet((tweet?.id)!, completion: { (response, error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
                self.tweet!.retweetCount = (self.tweet?.retweetCount?.integerValue)! - 1
                self.tweet?.retweeted = false
                self.retweetCountLabel.textColor = UIColor(red: 169/255.0, green: 184/255.0, blue: 193/255.0, alpha: 1)
                self.retweetCountLabel.text = "\((self.tweet?.retweetCount!)!)"
            })
        
        } else {
            TwitterClient.sharedInstance.retweet((tweet?.id)!) { (response, error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
                self.tweet?.retweetCount = (self.tweet?.retweetCount?.integerValue)! + 1
                self.tweet?.retweeted = true
                self.retweetCountLabel.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
                self.retweetCountLabel.text = "\((self.tweet?.retweetCount!)!)"
            }
        }
        
    }
    @IBAction func onLike(sender: AnyObject) {
        if tweet!.liked! {
            TwitterClient.sharedInstance.unLike((tweet?.id)!, completion: { (response, error) -> () in
                self.likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue - 1
                self.tweet!.liked = false
                self.likeCountLabel.textColor = UIColor(red: 169/255.0, green: 184/255.0, blue: 193/255.0, alpha: 1)
                self.likeCountLabel.text = "\((self.tweet?.likeCount!)!)"
            })
        
        } else {
            TwitterClient.sharedInstance.like((tweet?.id)!) { (response, error) -> () in
                self.likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                self.tweet?.likeCount = (self.tweet?.likeCount?.integerValue)! + 1
                self.tweet!.liked = true
                self.likeCountLabel.textColor = UIColor(red: 238/255.0, green: 22/255.0, blue: 79/255.0, alpha: 1)
                self.likeCountLabel.text = "\((self.tweet?.likeCount!)!)"
            }
        }
    }

}
