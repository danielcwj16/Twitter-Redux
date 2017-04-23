//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/15/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textcount: UILabel!
    @IBOutlet weak var tweettext: UITextView!
    
    var profile : User?
    var referenceTweet : Tweet?
    var isReply : Bool = false
    var defaultText : String = ""
    
    let MAX_CHAR_ALLOWED = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileData(profile: self.profile)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        
        self.tweettext.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func initProfileData(profile:User?){
        
        if let profile = profile{
            if let profileUrl = profile.profileUrl{
                self.profileImage.setImageWith(profileUrl)
            }else{
                self.profileImage.image = #imageLiteral(resourceName: "avatar")
            }
            self.nameLabel.text = profile.name
            self.screenNameLabel.text = "@\(profile.screenname ?? "")"
        }else{
            self.profileImage.image = #imageLiteral(resourceName: "avatar")
        }
        
        if isReply == true{
            
            self.tweettext.text = defaultText
        }
        
        let characteresRemaining = MAX_CHAR_ALLOWED - tweettext.text.characters.count
        self.textcount.text = "\(characteresRemaining)"
        self.textcount.textColor = characteresRemaining > 10 ? .darkGray : .red
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let characteresRemaining = MAX_CHAR_ALLOWED - tweettext.text.characters.count
        self.textcount.text = "\(characteresRemaining)"
        self.textcount.textColor = characteresRemaining > 10 ? .darkGray : .red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewTweet(_ sender: Any) {
        
        //performSegue(withIdentifier: "unwindSegueToNewTweet", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendNewTweet(_ sender: Any) {
        let newTweet = self.tweettext.text
        if isReply == true{
            if let refrenceId = referenceTweet?.id {
                TwitterClient.sharedInstance.replyTweet(tweet: newTweet ?? "", referenceId: refrenceId)
                
                print("post tweet: \(self.tweettext.text)")
            }
            
            performSegue(withIdentifier: "unwindSegueToTweetDetailVC", sender: self)
        }else{
            TwitterClient.sharedInstance.postTweet(tweet: newTweet ?? "")
            
            print("post tweet: \(self.tweettext.text)")
            
            performSegue(withIdentifier: "unwindSegueToNewTweet", sender: self)
        }
        
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
