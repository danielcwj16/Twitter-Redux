//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/16/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweettext: UILabel!
    @IBOutlet weak var retweetbutton: UIButton!
    @IBOutlet weak var favoritebutton: UIButton!
    @IBOutlet weak var retweetcount : UILabel!
    @IBOutlet weak var favouritecount : UILabel!
    
    var tweet : Tweet?
    var currentUser : User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTweetDetailData(tweet: tweet)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    func initTweetDetailData(tweet: Tweet?){
        if let tweet = tweet{
            if let profileUrl = tweet.user?.profileUrl{
                self.profileImage.setImageWith(profileUrl)
            }else{
                self.profileImage.image = #imageLiteral(resourceName: "avatar")
            }
            self.profilename.text = tweet.user?.name
            self.screenname.text = tweet.user?.screenname
            self.tweettext.text = tweet.text
        }else{
            self.profileImage.image = #imageLiteral(resourceName: "avatar")
        }
        
        if self.tweet?.retweeted == true{
            self.retweetbutton.setBackgroundImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
        }
        
        if self.tweet?.favorited == true{
            self.favoritebutton.setBackgroundImage(#imageLiteral(resourceName: "liked"), for: .normal)
        }
        
        self.retweetcount.text = "\(tweet?.retweetCount ?? 0)"
        self.favouritecount.text = "\(tweet?.favoritesCount ?? 0)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toReplyTweetVC"){
            let nav = segue.destination as! UINavigationController
            
            let replyTweetVC = nav.topViewController as! NewTweetViewController
            
            replyTweetVC.profile = self.currentUser
            replyTweetVC.isReply = true
            replyTweetVC.referenceTweet = self.tweet
            replyTweetVC.navigationItem.rightBarButtonItem?.title = "Reply"
            replyTweetVC.defaultText = "Replying to @\(self.tweet?.user?.screenname! ?? "")"
        }
        else{
            
        }
        
    }
    
    @IBAction func unwindToTweetDetailVC(segue: UIStoryboardSegue){
    
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        if self.tweet?.favorited != true{
            TwitterClient.sharedInstance.likeTweet(referenceId: (self.tweet?.id)!, success: {() in
                print("liked!")
                self.tweet?.favorited = true
                self.favoritebutton.setBackgroundImage(#imageLiteral(resourceName: "liked"), for: .normal)
                self.tweet?.favoritesCount += 1
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        }else{
            TwitterClient.sharedInstance.unlikeTweet(referenceId: (self.tweet?.id)!, success: {() in
                print("liked!")
                self.tweet?.favorited = false
                self.favoritebutton.setBackgroundImage(#imageLiteral(resourceName: "unliked"), for: .normal)
                self.tweet?.favoritesCount -= 1
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        }
        self.favouritecount.text = "\(tweet?.favoritesCount ?? 0)"
    }
    @IBAction func showRetweetActionSheet(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        
        var retweetAction = UIAlertAction(title: "Retweet", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if let referenceId = self.tweet?.id{
                TwitterClient.sharedInstance.reTweet(referenceId: referenceId, success: {() in
                    print("Retweet!")
                    self.tweet?.retweeted = true
                    self.retweetbutton.setBackgroundImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
                    self.tweet?.retweetCount += 1
                    self.retweetcount.text = "\(self.tweet?.retweetCount ?? 0)"
                }, failure: { (error:Error) in
                    print(error.localizedDescription)
                })
            }
            
        })
        
        if self.tweet?.retweeted == true{
            retweetAction = UIAlertAction(title: "Unretweet", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if let referenceId = self.tweet?.id{
                    TwitterClient.sharedInstance.unreTweet(referenceId: referenceId, success: {() in
                        print("Unretweet!")
                        self.tweet?.retweeted = false
                        self.retweetbutton.setBackgroundImage(#imageLiteral(resourceName: "retweet"), for: .normal)
                        self.tweet?.retweetCount -= 1
                        self.retweetcount.text = "\(self.tweet?.retweetCount ?? 0)"
                    }, failure: { (error:Error) in
                        print(error.localizedDescription)
                    })
                }
                
            })
        }
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("File Saved")
//        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(retweetAction)
        //optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
