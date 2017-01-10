//
//  RecevedPhotosViewController.swift
//  BluetoothModule
//
//  Created by THINK on 12/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import UIKit

class ReceivedImagesViewController: UIViewController, UINavigationControllerDelegate, UINavigationBarDelegate, UICollectionViewDataSource,UICollectionViewDelegate {
    var imageRec = UIImage()
    var imagesCollectionView : UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var images = [NewImage]()
   
    override func viewDidAppear(animated: Bool) {
        self.title = "Images In Range"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0 / 255.0, green: 90 / 255.0, blue: 230 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ReceivedImagesViewController.back))
        cancelButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionViewFlowLayout = makeANewCollectionViewFlowLayout()
        self.imagesCollectionView = makeANewCollectionView()
        self.imagesCollectionView.registerClass(ReceivedImagesCollectionViewCell.self, forCellWithReuseIdentifier: "receivedImagesCollectionViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let destinationVC = segue.destinationViewController as! BluetoothViewController
        
        if (segue.identifier == "toBluetoothView") {
            destinationVC.selectedImage = self.imageRec
        }
        
    }
    func back() {
        self.performSegueWithIdentifier("toBluetoothView", sender: self)
    }
    
    func makeANewCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: CGRectMake(0, 64, view.frame.width, view.frame.height - 64), collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        return collectionView
    }
    
    func makeANewCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(view.frame.width, view.frame.width)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.headerReferenceSize = CGSizeMake(0, 0)
        return flowLayout
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("receivedImagesCollectionViewCell", forIndexPath: indexPath) as! ReceivedImagesCollectionViewCell
        
        cell.usernameLabel.text = self.images[indexPath.row].newImageUser
        cell.timeLabel.text = self.images[indexPath.row].newImageTime
        cell.imageView.image = self.images[indexPath.row].newImageFile
        return cell
    }
}
