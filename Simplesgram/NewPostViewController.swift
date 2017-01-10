//
//  NewPostViewController.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/1.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts
import CoreLocation

class NewPostViewController: ResponsiveTextFieldViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate  {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    
    @IBOutlet weak var bright: UISlider!
    @IBOutlet weak var contrast: UISlider!
    
    @IBOutlet weak var brightLabel: UILabel!
    @IBOutlet weak var contrastLabel: UILabel!
    
    var currentLocation:CLPlacemark?=nil
    let locationManager=CLLocationManager()
    
    var filter: CIFilter!
    let context = CIContext(options: nil)
    var currentImage: UIImage!
    
    var extent: CGRect!
    var scaleFactor: CGFloat!

    @IBAction func normal(sender: AnyObject) {
        if(currentImage != nil){
            previewImage.image = currentImage
        }
        else{
            alert()
        }
    }
    
    @IBAction func mono(sender: AnyObject) {
        if (currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIPhotoEffectMono")
            filter?.setDefaults()
            filter?.setValue(show, forKey: kCIInputImageKey)
            showImage()
        }
        else{
            alert()
        }
    }
    
    @IBAction func pixel(sender: AnyObject) {
        if (currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIPixellate")
            filter?.setDefaults()
            filter?.setValue(show, forKey: kCIInputImageKey)
            filter?.setValue(max(show!.extent.size.width, show!.extent.size.height) / 90, forKey: kCIInputScaleKey)
            showImage()
            
        }else{
            alert()
        }
    }
    
    @IBAction func fade(sender: AnyObject) {
        if(currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIPhotoEffectFade")
            filter?.setDefaults()
            filter?.setValue(show, forKey: kCIInputImageKey)
            showImage()
        }else{
            alert()
        }
    }
    
    @IBAction func instant(sender: AnyObject) {
        if(currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIPhotoEffectInstant")
            filter?.setDefaults()
            filter?.setValue(show, forKey: kCIInputImageKey)
            showImage()
        }else{
            alert()
        }
    }
    
    
    @IBAction func btnbright(sender: AnyObject) {
        if(currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIColorControls")
            filter?.setDefaults()
            filter?.setValue((bright.value)/100, forKey: kCIInputBrightnessKey)
            filter?.setValue(show, forKey: kCIInputImageKey)
            showImage()
            
            let currentValue = Int(bright.value)
            brightLabel.text = "\(currentValue)%"
            
        }else{
            alert()
        }
    }
    
    
    @IBAction func contrast(sender: AnyObject) {
        if(currentImage != nil){
            let show = CIImage(image: currentImage)
            filter = CIFilter(name:"CIColorControls")
            filter?.setDefaults()
            filter?.setValue((contrast.value + 100)/100, forKey: kCIInputContrastKey)
            filter?.setValue(show, forKey: kCIInputImageKey)
            showImage()
            let currentValue = Int(contrast.value)
            contrastLabel.text = "\(currentValue)%"
        }else{
            alert()
        }
    }
    
    func showImage(){
        let img = context.createCGImage(filter!.outputImage!, fromRect: filter!.outputImage!.extent)
        let processedImage = UIImage(CGImage: img!)
        previewImage.image = processedImage
    }
    
    func alert(){
        /*
        let alert = UIAlertView(title: "NO PHOTOS", message: "Choose a picture, please!", delegate: self, cancelButtonTitle: "OK")
        alert.show()
        */
        let alert = UIAlertController(title: "NO PHOTOS", message: "Choose a picture, please!", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:90/255.0, blue:230/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.currentLocation = placemarks![0]
                self.locationManager.stopUpdatingLocation()
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
        currentImage = image
    }
    
    @IBAction func addImageFromCamera(sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let imageTaker=UIImagePickerController()
            imageTaker.delegate=self
            imageTaker.allowsEditing=true
            imageTaker.sourceType=UIImagePickerControllerSourceType.Camera
            imageTaker.mediaTypes=UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
            
            let pickerFrame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, imageTaker.view.bounds.width, imageTaker.view.bounds.height - imageTaker.navigationBar.bounds.size.height - imageTaker.toolbar.bounds.size.height - 53.0)
            let overlayView = UIImageView(frame: pickerFrame)
            
            overlayView.image = UIImage(named: "grid.png")
            imageTaker.cameraOverlayView = overlayView
            
            self.presentViewController(imageTaker,animated:true,completion:nil)
            
        }else{
            let alert = UIAlertView(title: "Oops", message: "Camera is not available!", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    @IBAction func postOut(sender: UIButton) {
        if(currentImage != nil){
            let date=NSDate()
            let dateFormatter=NSDateFormatter()
            dateFormatter.timeStyle=NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle=NSDateFormatterStyle.ShortStyle
            let localDate=dateFormatter.stringFromDate(date)
            let imageData=self.previewImage.image!.mediumQualityJPEGNSData
            
            let file :PFFile=PFFile(data: imageData)
            let fileCaption:String=self.captionField.text!
            let photoToUpload = PFObject(className: "Post")
            photoToUpload["userId"]=PFUser.currentUser()!.username
            photoToUpload["imgSource"]=file
            photoToUpload["subject"]=fileCaption
            photoToUpload["date"]=localDate
            photoToUpload["postBy"]=PFUser.currentUser()
            if let currentLocation=self.currentLocation{
                photoToUpload["locality"]=currentLocation.locality
                photoToUpload["postCode"]=currentLocation.postalCode
                photoToUpload["state"]=currentLocation.administrativeArea
                photoToUpload["country"]=currentLocation.country
                ParseQueryUtil.updateUserLatestLocation(currentLocation.postalCode!)
            }
            try! photoToUpload.save()
            /*
            let alert = UIAlertView(title: "Success", message: "Successful Upload", delegate: self, cancelButtonTitle: "OK")
            alert.show()*/
            let alert = UIAlertController(title: "Success", message: "Successful Upload", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }else{
            alert()
        }
//        let vc=self.storyboard?.instantiateViewControllerWithIdentifier("postsController")
//        self.presentViewController(vc as UIViewController!, animated: true, completion: nil)
//        do{try photoToUpload.save()}catch { }
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let destinationVC = segue.destinationViewController as! BluetoothViewController
        
        if (segue.identifier == "toBluetooth") {
            destinationVC.selectedImage = previewImage.image!
        }
        
        
        
    }
}
