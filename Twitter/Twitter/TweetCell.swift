//
//  TweetCell.swift
//  Twitter
//
//  Created by Weijie Chen on 4/15/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit
import LocalizedTimeAgo

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!

    
    var tweet : Tweet?{
        willSet(cellvaue){
            if cellvaue?.user?.profileUrl != nil
            {
                self.profileImage.setImageWith((cellvaue?.user?.profileUrl)!)}
            else{
                self.profileImage.image = #imageLiteral(resourceName: "avatar")
            }
            self.screenName.text = cellvaue?.user?.name
            self.username.text = "@\(cellvaue?.user?.screenname ?? "")"
            self.timestamp.text = cellvaue?.timestamp?.shortTimeAgo()
            self.tweetText.text = cellvaue?.text
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
