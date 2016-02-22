//
//  TweetsViewController.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/11/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SVPullToRefresh

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var tweets: [Tweet]?
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let image = UIImageView(image: UIImage(named: "Twitter_logo"))
        self.navigationItem.titleView = image
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Do any additional setup after loading the view.
        
        //pages = 20
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            let lastTweet = self.tweets![self.tweets!.count-1]
            let lastID = lastTweet.id
            let parameters:NSDictionary = ["max_id": lastID!]
            TwitterClient.sharedInstance.homeTimeLineWithParams(parameters, completion: { (tweets, error) -> Void in
                for tweet in tweets! {
                    if (tweet.id == lastID) {
                        continue
                    }
                    self.tweets?.append(tweet)
                }
                self.tableView.reloadData()
                self.tableView.infiniteScrollingView.stopAnimating()
            })
        }
        
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                self!.tweets = tweets
                self!.tableView.reloadData()
            })
            
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 0/255.0, green: 173/255.0, blue: 181/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            let user = tweet.user
            cell.usernameLabel.text = user?.name
            cell.profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            cell.screenName.text = "@\((user?.screenName)!)"
            cell.tweetLabel.text = tweet.text
            
            let time = Int((tweet.createdAt?.timeIntervalSinceNow)!)
            if (-time/3600) == 0 {
                cell.timeLabel.text = "\(-time/60)m"
            } else {
                cell.timeLabel.text = "\(-time/3600)h"
            }
            
            if tweet.retweeted! {
                cell.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
                cell.retweetCountLabel.textColor = UIColor(red: 0, green: 207/255.0, blue: 141/255.0, alpha: 1)
                cell.retweetCountLabel.text = "\(tweet.retweetCount!)"
            } else {
                cell.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
                cell.retweetCountLabel.textColor = UIColor(red: 169/255.0, green: 184/255.0, blue: 193/255.0, alpha: 1)
                cell.retweetCountLabel.text = "\(tweet.retweetCount!)"
            }
            
            if  tweet.liked! {
                cell.likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                cell.likeCountLabel.textColor = UIColor(red: 238/255.0, green: 22/255.0, blue: 79/255.0, alpha: 1)
                cell.likeCountLabel.text = "\(tweet.likeCount!)"
            } else {
                cell.likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                cell.likeCountLabel.textColor = UIColor(red: 169/255.0, green: 184/255.0, blue: 193/255.0, alpha: 1)
                cell.likeCountLabel.text = "\(tweet.likeCount!)"
            }
            
            cell.tweet = tweet
        }
        
        cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("displayTweet", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displayTweet") {
            let vc = segue.destinationViewController as! TweetDetailViewController
            let indexPath = sender as! NSIndexPath
            
            vc.tweet = self.tweets![indexPath.row]
        
        
        }
//        if (segue.identifier == "displayProfile") {
//                let vc = segue.destinationViewController as! TweetDetailViewController
//                let indexPath = sender as! NSIndexPath
//                
//                vc.tweet = self.tweets![indexPath.row]
//
//        }
    }
    
    @IBAction func onNew(sender: AnyObject) {
        performSegueWithIdentifier("displayNew", sender: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

}


extension UIScrollView {
    // to fix a problem where all the constraints of the tableview
    // are deleted
    func dg_stopScrollingAnimation() {}
}