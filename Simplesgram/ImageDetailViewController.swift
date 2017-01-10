//
//  ImageDetailViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/8.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ImageDetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var comments=[Comment]()
    var postDetail:Post?=nil
    var comeFromSegue:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        print(postDetail?.postID)
        self.imageView.image=postDetail?.image
        self.commentField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getLikes()
        self.getComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getLikes(){
        let query=PFQuery(className: "Likeship")
        query.whereKey("postID", equalTo: (postDetail?.postID)!)
        query.findObjectsInBackgroundWithBlock{
            (likes:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let likes=likes{
                    self.numberOfLikes.text=String(likes.count)
                }
            }else{
                print(error!.description)
            }
        }
        //numberOfLikes.text=String(try! query.findObjects().count)
    }
    func getComments(){
        let query=PFQuery(className: "Comment")
        query.orderByDescending("createdAt")
        query.whereKey("onPostID", equalTo: (postDetail?.postID)!)
        query.findObjectsInBackgroundWithBlock{
            (comments:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let comments=comments{
                    for comment in comments{
                        let c=Comment()
                        c.content=comment["content"] as? String
                        c.commentBy=comment["commentBy"] as? String
                        c.date=comment["date"] as? String
                        self.comments.append(c)
                    }
                }
                //can not delete this since it runs in other thread
                self.tableView.reloadData()
                self.numberOfComments.text=String(self.comments.count)
            }else{
                //Handle Error
                print(error!.description)
            }
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    
    @IBAction func sentComment(sender: UIButton) {
        let date=NSDate()
        let dateFormatter=NSDateFormatter()
        dateFormatter.timeStyle=NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle=NSDateFormatterStyle.ShortStyle
        let localDate=dateFormatter.stringFromDate(date)
        let commentToUpload = PFObject(className: "Comment")
        commentToUpload["commentBy"]=PFUser.currentUser()!.username
        commentToUpload["content"]=self.commentField.text
        commentToUpload["date"]=localDate
        commentToUpload["onPostID"]=postDetail?.postID
        //commentToUpload
        try! commentToUpload.save()
        //let alert = UIAlertView(title: "Success", message: "Successful Upload", delegate: self, cancelButtonTitle: "OK")
        //alert.show()
        let alert = UIAlertController(title: "Success:", message: "Successful Upload", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let c=Comment()
        c.content=self.commentField.text
        c.commentBy=PFUser.currentUser()!.username
        c.date=localDate
        self.comments.append(c)
        self.tableView.reloadData()
        self.numberOfComments.text=String(comments.count)
    }
//    @IBAction func backAction(sender: AnyObject) {
//        self.performSegueWithIdentifier("allPosts", sender: self)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        let comment=comments[indexPath.row]
        cell.commentator.text=comment.commentBy
        cell.DateLabel.text=comment.date
        cell.contentLabel.text=comment.content
        // Configure the cell...
//        let userCellContent=comments[indexPath.row]
//        cell.usernameLabel.text=userCellContent.username
//        if (userCellContent.followed){
//            cell.followButton.setTitle("followed", forState: UIControlState.Normal)
//            cell.followButton.enabled=false
//        }else{
//            cell.followButton.setTitle("follow", forState: UIControlState.Normal)
//            cell.followButton.enabled=true
//        }
        return cell
    }

}
