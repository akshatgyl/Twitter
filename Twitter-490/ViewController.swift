//
//  ViewController.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/8/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        
//        TwitterClient.sharedInstance.loginWithBlock() {
//            // go to next screen
//        }
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if (user != nil) {
                //perform my segue
            } else {
                // handle login error
                
            }
        }
        
       
        
       
        
    }
    
    
    
    
    
    
}

