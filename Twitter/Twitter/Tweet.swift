//
//  Tweet.swift
//  Twitter
//
//  Created by Weijie Chen on 4/14/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class Tweet {
    var id: String
    var text : String?
    var timestamp : Date?
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    var retweeted : Bool = false
    var favorited : Bool = false
    var user : User?
    
    init(dictionary : NSDictionary) {
        id = dictionary["id_str"] as! String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        user = User(dictionary : (dictionary["user"] as! NSDictionary))
    }
    
    class func tweetsWithArray(dictionaries : [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
