//
//  DiscoveryViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/6.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import Bolts

class DiscoveryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    //UI variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    // class variable
    var resultUsers=[User]()
    let locationManager=CLLocationManager()
    var currentPostalCode:String?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentPostCode()
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarSearchButtonClicked(userSearchBar: UISearchBar){
        print(userSearchBar.text)
        resultUsers.removeAll()
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", containsString: userSearchBar.text!)
        query.findObjectsInBackgroundWithBlock{
            (users:[PFObject]?, error:NSError?)->Void in
            if(error==nil){
                if let users=users{
                    for user in users{
                        //To Do avatar
                        //let rawImage=user["imgSource"] as! PFFile
                        // expection to be handled
                        if(String(user["username"]) != PFUser.currentUser()?.username){
                            let u=User()
                            u.username=user["username"] as! String
                            if GlobalVariable.followee.contains(u.username){
                                u.followed=true
                            }
                            self.resultUsers.append(u)
                        }
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultUsers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultUserCell", forIndexPath: indexPath) as! UserTableViewCell
        
        // Configure the cell...
        let userCellContent=resultUsers[indexPath.row]
        cell.usernameLabel.text=userCellContent.username
        if (userCellContent.followed){
            cell.followButton.setTitle("followed", forState: UIControlState.Normal)
            cell.followButton.enabled=false
        }else{
            cell.followButton.setTitle("follow", forState: UIControlState.Normal)
            cell.followButton.enabled=true
        }
        return cell
    }
    
    @IBAction func getSuggestedUsers(sender: AnyObject) {
        getUsersFromParse()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
           getUsersFromParse()
        }
    }
    
    
    
    func getUsersFromParse(){
        if let cPoCode=self.currentPostalCode{
            self.resultUsers.removeAll()
            let query : PFQuery = PFUser.query()!
            query.whereKey("lastPostPostcode", equalTo: cPoCode)
            query.findObjectsInBackgroundWithBlock{
                (users:[PFObject]?, error:NSError?)->Void in
                if(error==nil){
                    if let users=users{
                        for user in users{
                            //To Do avatar
                            //let rawImage=user["imgSource"] as! PFFile
                            // expection to be handled
                            if(String(user["username"]) != PFUser.currentUser()?.username){
                                let u=User()
                                u.username=user["username"] as! String
                                if GlobalVariable.followee.contains(u.username){
                                    u.followed=true
                                }
                                self.resultUsers.append(u)
                            }
                        }
                    }
                    //can not delete this since it runs in other thread
                    self.tableView.reloadData()
                }else{
                    //Handle Error
                    print(error!.description)
                }
            }
        } else {
            /*let alert = UIAlertView(title: "Notice", message: "busy in getting location try again", delegate: self, cancelButtonTitle: "OK")
            alert.show()*/
            let alert = UIAlertController(title: "Notice", message: "Busy in getting location,please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getCurrentPostCode(){
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil)
            {
                print("Error: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                self.currentPostalCode = placemarks![0].postalCode!
                self.locationManager.stopUpdatingLocation()
//                print("================")
//                print(self.currentPostalCode!)
                //self.getUsersFromParse()
            }
            else
            {
                print("Error with the data.")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
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
