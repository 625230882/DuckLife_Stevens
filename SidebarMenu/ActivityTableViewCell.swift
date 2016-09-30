//
//  ActivityTableViewCell.swift
//  StevensLife
//
//  Created by Xiao Li on 6/6/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var postImageView:UIImageView!
    //@IBOutlet weak var authorImageView:UIImageView!
    //@IBOutlet weak var postTitleLabel:UILabel!
    //@IBOutlet weak var authorLabel:UILabel!
    
   
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}