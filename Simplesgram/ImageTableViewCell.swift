//
//  ImageTableViewCell.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/9/28.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var avatarImg: UIImageView!
    
    var postID:String?=nil
    var liked:Bool=false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickLike(sender: UIButton) {
        if self.liked{
            ParseQueryUtil.dislike(self.postID!)
            likeButton.tintColor=UIColor.grayColor()
            self.liked=false
            GlobalVariable.likedPostsID.removeObject(self.postID!)
        }else{
            let likeship = PFObject(className: "Likeship")
            likeship["postID"]=self.postID
            likeship["likedBy"]=PFUser.currentUser()?.username
            likeship["likeby"]=PFUser.currentUser()
            try! likeship.save()
            likeButton.tintColor=UIColor.redColor()
            self.liked=true
            GlobalVariable.likedPostsID.append(self.postID!)
        }
        
    }
    @IBAction func clickComment(sender: UIButton) {
        let cell: UITableViewCell = sender.superview!.superview as! UITableViewCell
        let table: UITableView = cell.superview as! UITableView
        let textFieldIndexPath = table.indexPathForCell(cell)
    }
}

