//
//  ActivityItem.swift
//  Simplesgram
//
//  Created by Shi Yangguang on 15/10/9.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import Foundation
import Parse

class ActivityItem {
    var photo:UIImage?=nil
    var actBy:String?=nil
    var actTo:String?=nil
    var actTime: NSDate?=nil
    var image:UIImage? = nil
    
    var actTimeDistance:String{
        get{
            return getActTimeDistanceFromNow(actTime!)
        }
    }
    
    var isLikeActivity:Bool=false
    var postID:String?=nil
    
    
    
    
    func getActTimeDistanceFromNow(actTime: NSDate)->String{
        //TO DO
        //        actTimeDistance=""
        var tempTimeDistance:String?=nil
        let now = NSDate()
        let timeInterval: Double = now.timeIntervalSinceDate(actTime);
        
        if timeInterval/60 < 1{
            tempTimeDistance = String(format:"%.0f", timeInterval)+"s"
        }else if timeInterval/60 >= 1 && timeInterval/60 < 60{
            tempTimeDistance = String(format:"%.0f", timeInterval/60) + "min"
        }else if timeInterval/60/60 >= 1 && timeInterval/60/60 < 24{
            tempTimeDistance = String(format:"%.0f", timeInterval/3600)+"h"
        }else if timeInterval/60/60/24 >= 1{
            tempTimeDistance = String(format:"%.0f", timeInterval/86400)+"d"
        }
        return tempTimeDistance!
    }
    
    
    
    
    
    //following like
    init(actBy:String, actTime:NSDate,postID:String){
        self.actBy=actBy
        self.actTime=actTime
        self.postID=postID
    }
    
    
    //following like
    init(actBy:String,actTo:String, actTime:NSDate,postID:String, isLikeActivity:Bool){
        self.actBy=actBy
        self.actTo=actTo
        self.actTime=actTime
        self.postID=postID
        self.isLikeActivity = isLikeActivity
    }
    
    
    //following like with image
    init(actBy:String,actTo:String, image:UIImage,actTime:NSDate,postID:String, isLikeActivity:Bool){
        self.actBy=actBy
        self.actTo=actTo
        self.actTime=actTime
        self.postID=postID
        self.image=image
        self.isLikeActivity = isLikeActivity
        
    }
    
    //you
    init(actBy:String, actTime:NSDate){
        self.actBy=actBy
        self.actTime=actTime
    }
    
    //following
    init(actBy:String, actTo:String,actTime:NSDate){
        self.actBy=actBy
        self.actTo=actTo
        self.actTime=actTime
        
        
    }
    
    
}