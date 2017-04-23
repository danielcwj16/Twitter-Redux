//
//  TwitterClient.swift
//  Twitter
//
//  Created by Weijie Chen on 4/12/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

let twitterComsumerKey = "r4ko5frZVueeivk9A5HkcfEdy"
let twitterConsumerSecret = "5rEfLIYGD6RIKVnj1LLbcXpR2wP3AgyOpoYcnjEsYoqfIKqR3D"
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance : TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterComsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance!
    }
    
    func homeTimeline(count : Int = 20,success : @escaping ([Tweet]) -> (),failure : (Error) -> ()){
        let params = ["count":count]
        
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            let tweetsDictionary = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
            
            success(tweets)
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            
        })
    }
    
    func currentAccount(success : @escaping (User) -> (), failure : (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionTask, response:Any?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            success(user)
            print("name: \(user.name!)")
            print("screenname: \(user.screenname!)")
            print("profile url: \(user.profileUrl!)")
            print("description: \(user.tagline!)")
        }, failure: { (task:URLSessionTask?, error: Error) -> Void in
            
        })
    }
    
    func postTweet(tweet: String){
        let params = ["status":tweet]
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) in
            let newtweet = response as! NSDictionary
            print("text: \(newtweet["text"]!)")
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func replyTweet(tweet: String,referenceId: String){
        var params = ["status":tweet]
        params["in_reply_to_status_id"] = referenceId
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) in
            let newtweet = response as! NSDictionary
            print("text: \(newtweet["text"]!)")
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func reTweet(referenceId: String,success : @escaping () -> (), failure : (Error) -> ()){
        
        let params = ["id":referenceId]
        
        post("1.1/statuses/retweet/\(referenceId).json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) -> Void in
            //let retweet = response as! NSDictionary
        
            success()

        }, failure: { (task:URLSessionTask?, error: Error) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func unreTweet(referenceId: String,success : @escaping () -> (), failure : (Error) -> ()){
        
        let params = ["id":referenceId]
        
        post("1.1/statuses/unretweet/\(referenceId).json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) -> Void in
            //let retweet = response as! NSDictionary
            
            success()
            
        }, failure: { (task:URLSessionTask?, error: Error) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func likeTweet(referenceId: String,success : @escaping () -> (), failure : (Error) -> ()){
        
        let params = ["id":referenceId]
        
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) -> Void in
            //let retweet = response as! NSDictionary
            
            success()
            
        }, failure: { (task:URLSessionTask?, error: Error) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func unlikeTweet(referenceId: String,success : @escaping () -> (), failure : (Error) -> ()){
        
        let params = ["id":referenceId]
        
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) -> Void in
            //let retweet = response as! NSDictionary
            
            success()
            
        }, failure: { (task:URLSessionTask?, error: Error) -> Void in
            print(error.localizedDescription)
        })
    }

    
//    func reTweet(referenceId: String,success: @escaping (Bool) -> (),failure: (Error)->()){
//        let params = ["id":referenceId]
//        //params["in_reply_to_status_id"] = String(referenceId)
//        
//        post("1.1/statuses/retweet/\(referenceId).json", parameters: params, progress: nil, success: { (task:URLSessionTask, response:Any?) in
//            let retweet = response as! NSDictionary
//            success(true)
//            print("text: \(retweet["text"]!)")
//        }) { (task:URLSessionDataTask?, error:Error) in
//            print(error.localizedDescription)
//        }
//    }
    
    var loginSuccss: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()-> (),failure : @escaping (Error) -> ()){
        loginSuccss = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got token!")
            
            let token = requestToken.token!
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            UIApplication.shared.open(url)
        }, failure: {(error:Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure!(error)
        })
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("I got the acess token!")
            
            self.loginSuccss?()
        }) { (error:Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logOut(){
        deauthorize()
    }
}
