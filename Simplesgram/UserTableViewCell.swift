//
//  UserTableViewCell.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/6.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToFollow(sender: AnyObject) {
        let newFollowship=PFObject(className: "Followship")
        newFollowship["follower"]=PFUser.currentUser()!.username
        newFollowship["followee"]=usernameLabel.text!
        newFollowship["followBy"]=PFUser.currentUser()
        try! newFollowship.save()
        GlobalVariable.followee.append(usernameLabel.text!)
        followButton.setTitle("followed", forState: UIControlState.Normal)
        followButton.enabled=false
        
    }

}
