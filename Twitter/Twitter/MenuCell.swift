//
//  ManuCell.swift
//  Twitter
//
//  Created by Weijie Chen on 4/22/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var itemLabel : UILabel!
    
    var manuItemText : String?{
        didSet{
            self.itemLabel.text = manuItemText
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
