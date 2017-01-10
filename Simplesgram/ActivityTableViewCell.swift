//
//  ActivityTableViewCell.swift
//  Simplesgram
//
//  Created by Shi Yangguang on 15/10/12.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {


    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellPhoto: UIImageView! 
    @IBOutlet weak var cellLikeView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
