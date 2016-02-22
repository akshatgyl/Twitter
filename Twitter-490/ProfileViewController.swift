//
//  ProfileViewController.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/16/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    var tweet: Tweet?
    var user: User?
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = tweet?.user
        
        let backgroundUrl = tweet?.user?.backgroundImageUrl
        headerImageView.setImageWithURL(NSURL(string: backgroundUrl!)!)
        profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
        tweetsLabel.text = "\((user?.tweetsCount)!)\nTweets"
        followersLabel.text = "\((user?.followersCount)!)\nFollowers"
        followingLabel.text = "\((user?.followingCount)!)\nFollowing"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
