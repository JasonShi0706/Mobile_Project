//
//  UserProfileViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/5.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts

class UserProfileViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var postsData=[Post]()
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet weak var avatarImageField: UIImageView!
    @IBOutlet weak var usernameField: UILabel!  
    @IBOutlet weak var followerField: UILabel!
    @IBOutlet weak var followeeField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:90/255.0, blue:230/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        loadMyPosts()
        self.collectionView.reloadData()
        usernameField.text=PFUser.currentUser()?.username
        if let rawImage=PFUser.currentUser()?.valueForKey("avatarImg")as? PFFile{
            avatarImageField.image=UIImage(data: try!rawImage.getData())
        }
        followerField.text=String(GlobalVariable.follower.count)
        followeeField.text=String(GlobalVariable.followee.count)
        // Do any additional setup after loading the view.
    }

    @IBAction func refreshController(sender: AnyObject) {
        self.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchSortType(sender: UISwitch) {
        if sender.on{
            GlobalVariable.postSortBy="postCode"
        }else{
            GlobalVariable.postSortBy="createdAt"
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        //self.performSegueWithIdentifier("toLogin", sender: self)
    }
    
    //can not use ParseQueryUtil yet for delegate data reason
    func loadMyPosts(){
        postsData.removeAll()
        let query=PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.whereKey("userId", equalTo: (PFUser.currentUser()?.username)!)
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
                        self.postsData.append(p)
                    }
                }
                self.collectionView.reloadData()
            }else{
                print(error?.description)
                //Handle Error
            }
        }
    }
    
    //override collection method
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return postsData.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: myPostThumbnail = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! myPostThumbnail
        // TO DO!!
        let postCellContent=postsData[indexPath.row]
        cell.myPostPhotoField.image=postCellContent.image
        cell.dateField.text=postCellContent.date
        return cell
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "toDetail") {
            let cell: UICollectionViewCell = sender as! UICollectionViewCell
            
            
            let destinationVC = segue.destinationViewController as! ImageDetailViewController
            if let postIndex = collectionView.indexPathForCell(cell)?.row {
                destinationVC.postDetail = postsData[postIndex]
                //destinationVC.comeFromSegue="allPosts"
            }
        }
    }

}
