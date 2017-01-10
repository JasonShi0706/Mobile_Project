//
//  ImagesTableViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/9/28.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ImagesTableViewController: UITableViewController {
    var postsData=[Post]()
    var myRefreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:90/255.0, blue:230/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        //ParseQueryUtil.loadPosts(postsData,whereKey:nil,whereValue: nil)
//        while(!GlobalVariable.initialFlag){
//            let delay = 1 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue()) {
//                print("wait 1 sec")
//            }
//        }
        //loadAllPosts()
        //self.tableView.reloadData()
        self.myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(ImagesTableViewController.refreshPulled), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(myRefreshControl)
        GlobalVariable.getFollowShip(){
            self.refreshPulled()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.getMylikedPostsID()
//    }
    


    func refreshPulled(){
        self.postsData.removeAll()
        //ParseQueryUtil.loadPosts(postsData,whereKey:nil,whereValue: nil)
        loadAllPosts()
        self.tableView.reloadData()
        if self.myRefreshControl.refreshing
        {
            self.myRefreshControl.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func loadAllPosts(){
        //need a model to contain or directly use PFObject?
        GlobalVariable.getMylikedPostsID()
        let query=PFQuery(className: "Post")
        query.orderByDescending(GlobalVariable.postSortBy)        //query.whereKey("isSwipedPost", notEqualTo: true)
        var showPostsUsers: [String] = GlobalVariable.followee
        showPostsUsers.append((PFUser.currentUser()?.username)!)
        query.whereKey("userId", containedIn: showPostsUsers)
        query.includeKey("postBy")
        query.findObjectsInBackgroundWithBlock{
            (posts:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let posts=posts{
                    for post in posts{
                        let rawImage=post["imgSource"] as! PFFile
                        var locationCombine:String=""
                        if let locationCountry = post["country"]{
                            locationCombine=(locationCountry as! String)+" "+String(post["state"])+" "+String(post["locality"])
                        }
                        // expection to be handled
                        let p=Post(caption: post["subject"] as! String, image: UIImage(data: try! rawImage.getData())!, owner: post["userId"] as! String, date: post["date"] as! String, location: locationCombine,postID: post.objectId!)
                        if let addby=post["postBy"] as? PFObject{
                            if let rawAvatarImage=addby["avatarImg"] as? PFFile{
                                p.avatar=UIImage(data: try! rawAvatarImage.getData())!
                            }
                        }
                        self.postsData.append(p)
                    }
                }
                //can not delete this since it runs in other thread
                self.tableView.reloadData()
            }else{
                //Handle Error
                print(error!.description)
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsData.count
    }

   
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! ImageTableViewCell
        
        // Configure the cell...
        let postCellContent=postsData[indexPath.row]
        cell.postImageView.image=postCellContent.image
        cell.postCaption.text=postCellContent.caption
        cell.dateLabel.text=postCellContent.date
        cell.ownerLabel.text=postCellContent.owner
        cell.locationLabel.text=postCellContent.location
        cell.postID=postCellContent.postID
        cell.liked=GlobalVariable.likedPostsID.contains(postCellContent.postID)
        cell.avatarImg.image=postCellContent.avatar
        if cell.liked{
            cell.likeButton.tintColor = UIColor.redColor()
        }else{
            cell.likeButton.tintColor = UIColor.grayColor()
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send
        //var newProgramVar = Program(category: "Some", name: "Text")
        
        // Create a new variable to store the instance of PlayerTableViewController
        let cell: UITableViewCell = sender.superview!!.superview?.superview as! UITableViewCell
        
        
        let destinationVC = segue.destinationViewController as! ImageDetailViewController
        if let postIndex = tableView.indexPathForCell(cell)?.row {
            destinationVC.postDetail = postsData[postIndex]
            //destinationVC.comeFromSegue="allPosts"
        }
    }
}
