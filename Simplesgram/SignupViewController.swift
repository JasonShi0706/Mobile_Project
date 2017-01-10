//
//  SignupViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/1.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts


class SignupViewController: ResponsiveTextFieldViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var previewImage: UIImageView!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performSignUpAction(sender: AnyObject){
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        
        if (username!.characters.count < 4 || password!.characters.count < 5) {
            
            /*let alert = UIAlertView(title: "Invalid", message: "Username must be greater then 4 and Password must be greater then 5", delegate: self, cancelButtonTitle: "OK")
            alert.show()*/
            let alert = UIAlertController(title: "Invalid", message: "Username must be greater then 4 and Password must be greater than 5.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        } else if (email!.characters.count < 8) {
            
            /*let alert = UIAlertView(title: "Invalid", message: "Please enter a valid password.", delegate: self, cancelButtonTitle: "OK")
            alert.show()*/
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid password.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        } else {
            
            self.actInd.startAnimating()
            
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            if let imageData=self.previewImage.image?.lowestQualityJPEGNSData{
                let file :PFFile=PFFile(data: imageData)
                newUser.setValue(file, forKey: "avatarImg")
            }
            
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((error) != nil) {
                    
                    /*let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()*/
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    /*let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()*/
                    let alert = UIAlertController(title: "Success", message: "Signed Up", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    PFUser.logOut()
                    self.performSegueWithIdentifier("toLogin", sender: self)
                }
                
            })
            
        }
        
    }
    
    @IBAction func addImageFromLibrary(sender: AnyObject) {
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes=UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        imagePicker.allowsEditing=true
        self.presentViewController(imagePicker,animated:true,completion:nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.previewImage.image=image
        self.dismissViewControllerAnimated(true, completion: nil )
    }
    @IBAction func addImageFromCamera(sender: UIButton) {
        let imageTaker=UIImagePickerController()
        imageTaker.delegate=self
        imageTaker.allowsEditing=true
        imageTaker.sourceType=UIImagePickerControllerSourceType.Camera
        imageTaker.mediaTypes=UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
        self.presentViewController(imageTaker,animated:true,completion:nil)
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
