//
//  ParseQueryUtil.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/5.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import Foundation
import Parse
import Bolts
class ParseQueryUtil{
    //var postsData=[Post]()
    class func loadPosts(var postsData:[Post], whereKey:String?, whereValue:String?){
        let query=PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        if let whereKey=whereKey,whereValue=whereValue{
            query.whereKey(whereKey, equalTo: whereValue)
        }
        query.findObjectsInBackgroundWithBlock{
            (posts:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let posts=posts{
                    for post in posts{
                        let rawImage=post["imgSource"] as! PFFile
                        // expection to be handled
                        let p=Post(caption: post["subject"] as! String, image: UIImage(data: try! rawImage.getData())!, owner: post["userId"] as! String, date: post["date"] as! String,location:"",postID: post.objectId!)
                        postsData.append(p)
                    }
                }
            }else{
                print(error?.description)
                //Handle Error
            }
        }
    }
    
    class func updateUserLatestLocation(postcode:String){
        let query : PFQuery = PFUser.query()!

        query.whereKey("username", equalTo:(PFUser.currentUser()?.username)!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    query.getObjectInBackgroundWithId(object.objectId!){
                        (prefObj: PFObject?, error: NSError?) -> Void in
                        if error != nil {
                            print(error)
                        } else if let prefObj = prefObj {
                            prefObj["lastPostPostcode"] = postcode
                            try!prefObj.save()
                        }
                    }
                }
            }
        }
    }
    
    class func dislike(postID:String) {
        let query=PFQuery(className: "Likeship")
        query.whereKey("likedBy", equalTo:(PFUser.currentUser()?.username)!)
        query.whereKey("postID", equalTo:postID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    query.getObjectInBackgroundWithId(object.objectId!){
                        (prefObj: PFObject?, error: NSError?) -> Void in
                        if error != nil {
                            print(error)
                        } else if let prefObj = prefObj {
                            try!prefObj.delete()
                        }
                    }
                }
            }
        }
    }
}