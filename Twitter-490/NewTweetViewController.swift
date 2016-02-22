//
//  NewTweetViewController.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/20/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var wordCountLabel: UILabel!
    var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordCountLabel.text = "\((self.counter))"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(sender: AnyObject) {
        
        TwitterClient.sharedInstance.postTweet(statusTextField.text!) { (error) -> () in
            
        }
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func textFieldChanged(sender: AnyObject) {
        counter = 140 - (statusTextField.text?.characters.count)!
        if (counter < 0) {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Word limit exceeded"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        counter = 140 - (statusTextField.text?.characters.count)!
        wordCountLabel.text = "\(self.counter)"
        
        
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
