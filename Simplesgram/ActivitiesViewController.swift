//
//  ActivitiesViewController.swift
//  Simplesgram
//
//  Created by Shi Yangguang on 15/10/9.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts


class ActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    , UITableViewDelegate, UITableViewDataSource
    var activityDataYou=[ActivityItem]()
    var activityDataFollowing=[ActivityItem]()
    
    @IBOutlet weak var ActivityTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    var activities:[ActivityItem]?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:90/255.0, blue:230/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getActivities()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getActivities(){
        //Activity query
        activityDataYou.removeAll()
        activityDataFollowing.removeAll()
        //query, assign to activities "YOU"
        let query = PFQuery(className: "Followship")
        query.orderByDescending("createdAt")
        query.whereKey("followee", equalTo: (PFUser.currentUser()?.username)!)
        query.includeKey("followBy")
        
        query.findObjectsInBackgroundWithBlock{
            (followships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let followships=followships{
                    for fs in followships{
                        // get the photo from database table "user"
                        let you = ActivityItem(actBy: fs["follower"] as! String, actTime: fs.createdAt!)
                        
                        you.photo  = UIImage(named: "circle-user-7")
                        if let addby=fs["followBy"] as? PFObject{
                            if let rawAvatarImage=addby["avatarImg"] as? PFFile{
                                you.photo=UIImage(data: try! rawAvatarImage.getData())!
                            }
                        }
                        
                        self.activityDataYou.append(you)
                    }
                }
                self.ActivityTableView.reloadData()
            }else{
                //Handle Error
                print(error!.description)
            }
        }
        
        //query for "FOLLOWING"
        let query1 = PFQuery(className: "Followship")
        query1.orderByDescending("createdAt")
        let showFollowee: [String] = GlobalVariable.followee
        query1.whereKey("follower", containedIn: showFollowee)
        query1.includeKey("followBy")
        query1.findObjectsInBackgroundWithBlock{
            (followships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let followships=followships{
                    for fs in followships{
                        //                        GlobalVariable.followee.append(fs["followee"] as! String)
                        
                        let a = ActivityItem(actBy: fs["follower"] as! String, actTo: fs["followee"] as! String, actTime: fs.createdAt!)
                        
                        a.photo  = UIImage(named: "circle-user-7")
                        if let addby=fs["followBy"] as? PFObject{
                            if let rawAvatarImage=addby["avatarImg"] as? PFFile{
                                a.photo = UIImage(data: try! rawAvatarImage.getData())!
                            }
                        }
                        self.activityDataFollowing.append(a)
                    }
                }
                self.ActivityTableView.reloadData()
            }else{
                //Handle Error
                print(error!.description)
            }
        }
        
        
        //query for "FOLLOWING" like
        let query2 = PFQuery(className: "Likeship")
        query2.orderByDescending("createdAt")
        //        var showFollowee: [String] = GlobalVariable.followee
        query2.whereKey("likedBy", containedIn: showFollowee)
        query2.includeKey("likeby")
        query2.findObjectsInBackgroundWithBlock{
            (likeships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let likeships=likeships{
                    for fs in likeships{
                        //                       GlobalVariable.followee.append(fs["followee"] as! String)
                        let like = ActivityItem(actBy: fs["likedBy"] as! String, actTo: "Luke", actTime: fs.createdAt!, postID: fs["postID"] as! String, isLikeActivity: true)
                        
                        //get the photo of user
                        like.photo  = UIImage(named: "circle-user-7")
                        if let addby=fs["likeby"] as? PFObject{
                            if let rawAvatarImage=addby["avatarImg"] as? PFFile{
                                like.photo = UIImage(data: try! rawAvatarImage.getData())!
                            }
                        }
                        
                        // get the name of "followee" which is "userId" in table "Post" and get the post image
                        // thread problem
                        let query3 = PFQuery(className: "Post")
                        query3.whereKey("objectId", equalTo: (fs["postID"] as! String))
                        //                        query3.whereKey("objectId", equalTo: (like.postID)!)
                        query3.findObjectsInBackgroundWithBlock{
                            (posts:[PFObject]?, error:NSError?)->Void in
                            if(error==nil){
                                if let posts=posts{
                                    for p in posts{
                                        let rawImage=p["imgSource"] as! PFFile
                                        like.actTo = p["userId"] as? String
                                        // here you can add a picture
                                        //...........
                                        like.image = UIImage(data: try! rawImage.getData())!
                                    }
                                }
                                self.ActivityTableView.reloadData()
                            }else{
                                //Handle Error
                                print(error!.description)
                            }
                        }
                        self.activityDataFollowing.append(like)
                    }
                }
                self.ActivityTableView.reloadData()
            }else{
                //Handle Error
                print(error!.description)
            }
            
        }
        
        //query for "YOU" like
        let query4 = PFQuery(className: "Likeship")
        query4.orderByDescending("createdAt")
        //        var showFollowee: [String] = GlobalVariable.followee
        query4.whereKey("likedBy", equalTo: (PFUser.currentUser()?.username)!)
        query4.includeKey("likeby")
        query4.findObjectsInBackgroundWithBlock{
            (likeships:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let likeships=likeships{
                    for fs in likeships{
                        //                       GlobalVariable.followee.append(fs["followee"] as! String)
                        let like = ActivityItem(actBy: fs["likedBy"] as! String, actTo: "Luke", actTime: fs.createdAt!, postID: fs["postID"] as! String, isLikeActivity: true)
                        
                        //get the photo of user
                        like.photo  = UIImage(named: "circle-user-7")
                        if let addby=fs["likeby"] as? PFObject{
                            if let rawAvatarImage=addby["avatarImg"] as? PFFile{
                                like.photo = UIImage(data: try! rawAvatarImage.getData())!
                            }
                        }
                        
                        // get the name of "followee" which is "userId" in table "Post" and get the post image
                        // thread problem
                        let query5 = PFQuery(className: "Post")
                        query5.whereKey("objectId", equalTo: (fs["postID"] as! String))
                        //                        query3.whereKey("objectId", equalTo: (like.postID)!)
                        query5.findObjectsInBackgroundWithBlock{
                            (posts:[PFObject]?, error:NSError?)->Void in
                            if(error==nil){
                                if let posts=posts{
                                    for p in posts{
                                        let rawImage=p["imgSource"] as! PFFile
                                        like.actTo = p["userId"] as? String
                                        // here you can add a picture
                                        //...........
                                        like.image = UIImage(data: try! rawImage.getData())!
                                    }
                                }
                                self.ActivityTableView.reloadData()
                            }else{
                                //Handle Error
                                print(error!.description)
                            }
                        }
                        self.activityDataYou.append(like)
                    }
                }
                self.ActivityTableView.reloadData()
            }else{
                //Handle Error
                print(error!.description)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var returnValue = 0
        
        print(mySegmentedControl.selectedSegmentIndex)
        switch(mySegmentedControl.selectedSegmentIndex){
        case 0:
            returnValue = activityDataFollowing.count
            break
        case 1:
            returnValue = activityDataYou.count
            break
        default:
            break
        }
        return returnValue
    }
    
    //index path: which section and which row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //"myActivityCell"
        let cell = tableView.dequeueReusableCellWithIdentifier("myActivityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        //            as! ActivityViewCell
        cell.cellPhoto.layer.cornerRadius = 20
        cell.cellPhoto.layer.masksToBounds = true
        cell.cellLabel?.font = UIFont(name:"Avenir", size:12)
        cell.cellLabel?.numberOfLines = 2
        // sort the array in the order of time
        activityDataFollowing.sortInPlace({$0.actTime!.timeIntervalSinceNow > $1.actTime!.timeIntervalSinceNow})
        activityDataYou.sortInPlace({$0.actTime!.timeIntervalSinceNow > $1.actTime!.timeIntervalSinceNow})
        
        switch(mySegmentedControl.selectedSegmentIndex){
        case 0:
            //Activity for "FOLLOWING"
            if activityDataFollowing[indexPath.row].isLikeActivity == false {
                cell.cellPhoto.image =  activityDataFollowing[indexPath.row].photo
                cell.cellLabel?.text = activityDataFollowing[indexPath.row].actBy!+" started following " + activityDataFollowing[indexPath.row].actTo!+". "+activityDataFollowing[indexPath.row].actTimeDistance
                cell.cellLikeView.image = nil
                break
            }
            
            if activityDataFollowing[indexPath.row].isLikeActivity == true {
                cell.cellPhoto.image =  activityDataFollowing[indexPath.row].photo
                cell.cellLabel?.text = activityDataFollowing[indexPath.row].actBy!+" liked " + activityDataFollowing[indexPath.row].actTo!+"'s "+"photos. "+activityDataFollowing[indexPath.row].actTimeDistance
                cell.cellLikeView.image = activityDataFollowing[indexPath.row].image
                break
            }
            
        case 1:
            // activity for "YOU"
            
            if activityDataYou[indexPath.row].isLikeActivity == false {
                cell.cellPhoto.image =  activityDataYou[indexPath.row].photo
                cell.cellLabel?.text =  activityDataYou[indexPath.row].actBy!+" started following you. "+activityDataYou[indexPath.row].actTimeDistance
                cell.cellLikeView.image = nil
                break
            }
            
            if activityDataYou[indexPath.row].isLikeActivity == true {
                //                cell.cellPhoto.image = UIImage(named: "circle-user-7")
                cell.cellPhoto.image =  activityDataYou[indexPath.row].photo
                cell.cellLabel?.text = "You liked " + activityDataYou[indexPath.row].actTo!+"'s "+"photos. "+activityDataYou[indexPath.row].actTimeDistance
                cell.cellLikeView.image = activityDataYou[indexPath.row].image
                break
            }
            
        default:
            break
        }
        return cell
    }
    
    
    @IBAction func SegmentedChangeActivity(sender: AnyObject) {
        ActivityTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
