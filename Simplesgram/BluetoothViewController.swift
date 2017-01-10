//
//  ViewController.swift
//  BluetoothModule
//
//  Created by THINK on 1/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//
import UIKit
import Parse
import MultipeerConnectivity

class BluetoothViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UINavigationBarDelegate, BluetoothDelegate {
    var appDelegate : AppDelegate!
    var friendsTableView : UITableView!
    var sendButton : UIButton!
    var selectedImage = UIImage()
    var imageView : UIImageView!
    
    override func viewDidAppear(animated: Bool) {

        self.title = "Friends In Range"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0 / 255.0, green: 90 / 255.0, blue: 230 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BluetoothViewController.back))
        let receivedPhotoButton = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BluetoothViewController.more))
        cancelButton.tintColor = UIColor.whiteColor()
        receivedPhotoButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = receivedPhotoButton
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if self.appDelegate.bluetooth == nil {
            self.appDelegate.bluetooth = Bluetooth()
        }
        self.appDelegate.bluetooth.bluetoothDelegate = self
        self.friendsTableView = makeANewTableView()
        self.friendsTableView.reloadData()
        self.view.backgroundColor = self.friendsTableView.backgroundColor
        self.imageView = makeAnImageView()
        self.imageView.image = self.selectedImage
        self.friendsTableView.registerClass(FoundTableViewCell.classForCoder(), forCellReuseIdentifier: "foundTableViewCell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BluetoothViewController.notificationHandler(_:)), name: "NewPhoto", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toReceivedImagesView") {
            let destinationVC = segue.destinationViewController as! ReceivedImagesViewController
            destinationVC.imageRec = self.selectedImage
            destinationVC.images = self.appDelegate.receivedImages
        }
    }
    
    func notificationHandler(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        let data = receivedDataDictionary["Data"] as? NSData
        let fromUser = receivedDataDictionary["FromUser"] as? MCPeerID
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, UIImage>
        let imageReceive = dataDictionary["image"]
        let timeReceive = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        self.appDelegate.receivedImages.append(NewImage(user: fromUser!.displayName, time: timeReceive, image: imageReceive!))
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            let username = fromUser!.displayName
            let alert = UIAlertController(title: "receive:", message: "receive a image from \(username).", preferredStyle: UIAlertControllerStyle.Alert)
        
        let imageView = UIImageView(frame: CGRectMake(10, 10, 40, 40))
        imageView.image = imageReceive
        alert.view.addSubview(imageView)
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(declineAction)
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.presentViewController(alert, animated: true, completion: nil)
        }
        })
    }
    
    func foundUser() {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.friendsTableView.reloadData()
        }
    }
    
    func lostUser(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            for anyImage in self.appDelegate.receivedImages {
                if anyImage.newImageUser.isEqual(peerID.displayName) {
                    let index = self.appDelegate.receivedImages.indexOf(anyImage)
                    self.appDelegate.receivedImages.removeAtIndex(index!)
                }
            }
            self.friendsTableView.reloadData()
        }
    }
    
    func refresh(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.friendsTableView.reloadData()
        }
    }
    func makeAnImageView() -> UIImageView {
        let imgView = UIImageView()
        
        imgView.frame = CGRectMake(view.frame.width / 4, 65, view.frame.width / 2, view.frame.width / 2)
        self.view.addSubview(imgView)
        return imgView
    }
    
    func makeANewTableView() -> UITableView {
        //add a table view to list the found friends
        let findFriendsTableView = UITableView(frame: CGRectMake(0, self.makeAnImageView().frame.height + 30, self.view.frame.width, self.view.frame.height - 50), style: .Grouped)
        findFriendsTableView.delegate = self
        findFriendsTableView.dataSource = self
        findFriendsTableView.separatorStyle = .None
        self.view.addSubview(findFriendsTableView)
        return findFriendsTableView
    }
    
    func back() {
        self.performSegueWithIdentifier("backToPost", sender: self)
    }
    
    func more() {
        
        let alertController = UIAlertController(title: "More operations", message: "Select one of the operations that you want to do from below:", preferredStyle: .Alert)
        
        if self.appDelegate.bluetooth.isBrowsering == false {
            let startScanAction = UIAlertAction(title: "Start scan user in range", style: .Default, handler: {(action) in
                self.appDelegate.bluetooth.bluetoothBrowser.startBrowsingForPeers()
                self.appDelegate.bluetooth.isBrowsering = true
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.friendsTableView.reloadData()
                }
            })
            alertController.addAction(startScanAction)
        }
        else {
            let stopScanAction = UIAlertAction(title: "Stop scan user in range", style: .Default, handler: {(action) in
                self.appDelegate.bluetooth.bluetoothBrowser.stopBrowsingForPeers()
                self.appDelegate.bluetooth.isBrowsering = false
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.friendsTableView.reloadData()
                }
            })
            alertController.addAction(stopScanAction)
        }
        
        if self.appDelegate.bluetooth.isAdvertising == false {
            let startAdvertiseAction = UIAlertAction(title: "Start advertising myself in range", style: .Default, handler: {(action) in
                self.appDelegate.bluetooth.bluetoothAdvertiser.startAdvertisingPeer()
                self.appDelegate.bluetooth.isAdvertising = true
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.friendsTableView.reloadData()
                }
            })
            alertController.addAction(startAdvertiseAction)
        }
        else {
            let stopAdvertiseAction = UIAlertAction(title: "Stop advertising myself in range", style: .Default, handler: {(action) in
                self.appDelegate.bluetooth.bluetoothAdvertiser.stopAdvertisingPeer()
                self.appDelegate.bluetooth.isAdvertising = false
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.friendsTableView.reloadData()
                }
            })
            alertController.addAction(stopAdvertiseAction)
        }
        
        let sendAction = UIAlertAction(title: "Send the Image to others", style: .Default, handler: {(action) in
            var toSendUsers = [MCPeerID]()
            for user in self.appDelegate.bluetooth.foundInRangeUsers {
                if user.isSelected {
                    toSendUsers.append(user.foundUserID)
                }
            }
            if toSendUsers.count > 0 {
                let messageDictionary: [String: UIImage] = ["image": self.selectedImage]
                self.appDelegate.bluetooth.sendPhoto(timeAndImage: messageDictionary, targetUsers: toSendUsers)
            }
            else {
                let alert = UIAlertController(title: "No User Selected", message: "You should select at least one user before send.", preferredStyle: .Alert)
                let startScanAction = UIAlertAction(title: "Cancel", style: .Cancel , handler: nil)
                alert.addAction(startScanAction)
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        })
        alertController.addAction(sendAction)
        
        let imagesAction = UIAlertAction(title: "See images from users in range", style: .Default, handler: {(action) in
            
            self.performSegueWithIdentifier("toReceivedImagesView", sender: self)
        })
        alertController.addAction(imagesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.bluetooth.foundInRangeUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("foundTableViewCell", forIndexPath: indexPath) as! FoundTableViewCell
        if cell.isEqual(nil) {
            cell = FoundTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "foundTableViewCell")
        }
        cell.nameLabel.text = "Name: " + self.appDelegate.bluetooth.foundInRangeUsers[indexPath.row].foundUserID.displayName
        cell.stateLabel.text = self.appDelegate.bluetooth.foundInRangeUsers[indexPath.row].connectState.rawValue.lowercaseString
        
        if self.appDelegate.bluetooth.foundInRangeUsers[indexPath.row].isFriend {
            cell.relationLabel.text = "A friend"
        }
        else {
            cell.relationLabel.text = "An user in range"
        }
        
        if self.appDelegate.bluetooth.foundInRangeUsers[indexPath.row].isSelected{
            cell.selectedLabel.text = "Selected"
        }
        else {
            cell.selectedLabel.text = "Not selected"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! FoundTableViewCell
        let row = self.appDelegate.bluetooth.foundInRangeUsers[indexPath.row]
        if row.isSelected == true {
            row.isSelected = false
            currentCell.selectedLabel.text = "Not Selected"
        }
        else {
            row.isSelected = true
            currentCell.selectedLabel.text = "Selected"
        }
    }
}

