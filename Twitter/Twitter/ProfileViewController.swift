//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/22/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var userTimelineView: UITableView!
    var currentUser : User?
    var userTimeline : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance.currentAccount(success: { (user: User) in
            self.currentUser = user
            self.loadProfileData(user: self.currentUser!)
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        titleView.image = #imageLiteral(resourceName: "navtitleimage")
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
        
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 2.0
        
        userTimelineView.delegate = self
        userTimelineView.dataSource = self
        userTimelineView.estimatedRowHeight = 50
        userTimelineView.rowHeight = UITableViewAutomaticDimension
        
        initUserTimeline()
        
        // Do any additional setup after loading the view.
    }
    
    func initUserTimeline(){
        TwitterClient.sharedInstance.userTimeline(success: { (tweets:[Tweet]) in
            self.userTimeline = tweets
            
            for tweet in tweets{
                print(tweet.text ?? "")
            }
            
            self.userTimelineView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTimeline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTimelineView.dequeueReusableCell(withIdentifier: "UserTimelineCell", for: indexPath) as! TweetCell
        cell.tweet = self.userTimeline[indexPath.row]
        
        return cell
    }
    
    func loadProfileData(user: User){
        if let profileUrl = user.profileUrl{
            self.profileImage.setImageWith(profileUrl)
        }else{
        }
        self.name.text = user.name ?? ""
        self.screenname.text = "@\(user.screenname ?? "")"
        self.tweetsCount.text = "\(user.tweetscount )"
        self.followingCount.text = "\(user.followingcount)"
        self.followerCount.text = "\(user.followerscount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance.logOut()
        
        performSegue(withIdentifier: "profileVCUnwindToLoginVC", sender: self)
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
