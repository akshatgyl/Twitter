//
//  User.swift
//  Twitter-490
//
//  Created by Akshat Goyal on 2/9/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        profileImageUrl = dictionary["profile_image_url"] as! String
        tagline = dictionary["description"] as! String
        
    }
}
