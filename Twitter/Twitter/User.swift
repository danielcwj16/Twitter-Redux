//
//  User.swift
//  Twitter
//
//  Created by Weijie Chen on 4/14/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class User {
    var id:Int
    var name : String?
    var screenname : String?
    var profileUrl : URL?
    var tagline: String?
    
    init(dictionary : NSDictionary) {
        id = dictionary["id"] as! Int
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
        
    }
}
