//
//  Post.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/3.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
class Post {
    var caption:String
    var image:UIImage?
    var owner:String
    var date:String
    var location:String
    var postID:String
    var avatar:UIImage = UIImage(named:"circle-user-7")!
    
    init(caption:String,image:UIImage, owner:String,date:String,location:String,postID:String){
        self.caption=caption
        self.image=image
        self.owner=owner
        self.date=date
        self.location=location
        self.postID=postID
    }
}
