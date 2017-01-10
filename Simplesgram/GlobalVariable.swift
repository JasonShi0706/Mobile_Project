//
//  GlobalVariable.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/6.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import Foundation
import Parse
import Bolts

class GlobalVariable {
    static var followee = [String]()
    static var follower = [String]()
    static var likedPostsID=[String]()
    static var postSortBy:String="createdAt"
    //static var lastPostPostcode:String=""
   // static var currentPositionPostcode:String=""
    
    class func getFollowShip(completionHandler: (() -> Void)!){
        GlobalVariable.followee.removeAll()
        GlobalVariable.follower.removeAll()
        let query=PFQuery(className: "Followship")
        query.orderByDescending("createdAt")
        query.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock{
            (followships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let followships=followships{
                    for fs in followships{
                        GlobalVariable.followee.append(fs["followee"] as! String)
                    }
                }
            }else{
                //Handle Error
                print(error!.description)
            }
        }
        let query2=PFQuery(className: "Followship")
        query2.orderByDescending("createdAt")
        query2.whereKey("followee", equalTo: (PFUser.currentUser()?.username)!)
        query2.findObjectsInBackgroundWithBlock{
            (followships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let followships=followships{
                    for fs in followships{
                        GlobalVariable.follower.append(fs["follower"] as! String)
                    }
                }
            }else{
                //Handle Error
                print(error!.description)
            }
            completionHandler()
        }
    }
    
    class func getMylikedPostsID(){
        self.likedPostsID.removeAll()
        let query=PFQuery(className: "Likeship")
        query.whereKey("likedBy", equalTo:(PFUser.currentUser()?.username)!)
        let objects:[PFObject]=try! query.findObjects()//InBackgroundWithBlock {
        //(objects: [PFObject]?, error: NSError?) -> Void in
        //            if error == nil {
        for object in objects {
            self.likedPostsID.append(object["postID"] as! String)
        }
        //            }else{
        //                print(error)
        //            }
        //}
    }
}