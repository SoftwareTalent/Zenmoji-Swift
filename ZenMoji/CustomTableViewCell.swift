//
//  CustomTableViewCell.swift
//  ZenEmoji
//
//  Created by CSPC143 on 18/05/17.
//  Copyright © 2017 CSPC143. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emojiImageView : UIImageView?
    @IBOutlet weak var nameLabel : UILabel?
    @IBOutlet weak var priceLabel : UILabel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
