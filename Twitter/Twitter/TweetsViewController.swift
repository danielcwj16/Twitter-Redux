//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/14/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    var tweets : [Tweet] = []
    var currentUser : User?
    var refreshControl = UIRefreshControl()
    var loadingMoreView : InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var contentOffset : CGPoint?
    
    @IBOutlet weak var tweetsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        titleView.image = #imageLiteral(resourceName: "navtitleimage")
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
        //self.navigationItem.titleView?.contentMode = .center
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 50
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tweetsTableView.addSubview(loadingMoreView!)
        
        var insets = tweetsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetsTableView.contentInset = insets
        
        contentOffset = tweetsTableView.contentOffset
        
        initTimelineData()
        
                // Do any additional setup after loading the view.
    }
    
//    @IBAction func composeNewTweet(_ sender: Any) {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let newTweetVC = mainStoryboard.instantiateViewController(withIdentifier: "NewTweetVC") as! NewTweetViewController
//        
//        self.present(newTweetVC, animated: true, completion: nil)
//    }
    
    func initTimelineData(){
        TwitterClient.sharedInstance.currentAccount(success: { (user: User) in
            self.currentUser = user
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            
            for tweet in tweets{
                print(tweet.text ?? "")
            }
            
            self.tweetsTableView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func refreshTimeline(){
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            
            for tweet in tweets{
                print(tweet.text ?? "")
            }
            
            self.tweetsTableView.reloadData()
            
            self.refreshControl.endRefreshing()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && !tweetsTableView.isDragging){
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimeline(count: (self.tweets.count+20),success: { (tweets:[Tweet]) in
            
            self.isMoreDataLoading = false
            self.tweets = tweets
            
            for tweet in tweets{
                print(tweet.text ?? "")
            }
            
            self.loadingMoreView!.stopAnimating()
            
            
            self.tweetsTableView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = self.tweets[indexPath.row]
        
        return cell
    }
    
    @IBAction func unwindToTweetsVC(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func onLogout(sender: Any){
        TwitterClient.sharedInstance.logOut()
        performSegue(withIdentifier: "unwindSeguiToLoginVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toNewTweetVC"){
            let nav = segue.destination as! UINavigationController
            
            let newTweetVC = nav.topViewController as! NewTweetViewController
            
            newTweetVC.profile = self.currentUser
        }
        else if(segue.identifier == "toTweetDetailVC"){
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            
            let indexpath = tweetsTableView.indexPath(for: sender as! TweetCell)
            
            let row = indexpath?.row
            
            tweetDetailVC.tweet = self.tweets[row!]
            tweetDetailVC.currentUser = self.currentUser
        }else{
            
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
