//
//  LoginViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/9/25.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class LoginViewController: ResponsiveTextFieldViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    
    var logInViewController:PFLogInViewController! = PFLogInViewController()
    var signUpViewController:PFSignUpViewController! = PFSignUpViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() != nil) {
            print(PFUser.currentUser())
            //GlobalVariable.getFollowShip((print("finished"))->Void)
            self.performSegueWithIdentifier("postsView", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: UIButton) {
        let username=usernameField.text
        let password=passwordField.text
        self.actInd.startAnimating()
        PFUser.logInWithUsernameInBackground(username!, password: password!){
            (user:PFUser?, error:NSError?)->Void in
            self.actInd.stopAnimating()
            if (error==nil){
                print("Successful")
                //GlobalVariable.lastPostPostcode=user?.valueForKey("lastPostPostcode") as! String
                //GlobalVariable.getFollowShip((print("finished")->Void)!)
                self.performSegueWithIdentifier("postsView", sender: self)
            }else{
                let alertController=UIAlertController(title: "Error", message: "Incorrect username/password", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func toSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("signUp", sender: self)
    }
    
    
    
}
